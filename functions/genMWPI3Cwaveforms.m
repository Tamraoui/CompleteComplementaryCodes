function [multiWaveforms] = genMWPI3Cwaveforms(ccc, angles,xArray, fs, c)

    numSamples = size(ccc{1}, 2);
    numAngles = length(angles);
    na=numel(angles);
    numElements=numel(xArray);
    for nacq = 1:na
        % Build polarity matrix: [numSamples x na]
        wavePolarity = zeros(numSamples, na);
        for i = 1:na
            wavePolarity(:, i) = ccc{i}(nacq, :);
        end

        % Compute delay shifts for each angle
        shift = zeros(na, numElements);
        for k = 1:numAngles
            alpha = angles(k);
            delaysTx = xArray .* sind(alpha) / c;
            delaysTx = delaysTx - min(delaysTx);
            shift(k, :) = round(delaysTx * fs);
        end

        waves_delay = zeros(1, na);
        multiWV = [];

        for i = 1:na
            maxShift = max(shift(i, :));
            buf = zeros(maxShift + numSamples, numElements);

            for j = 1:numElements
                startIdx = shift(i, j) + 1;
                buf(startIdx:startIdx + numSamples - 1, j) = wavePolarity(:, i);
            end

            if i > 1
                % Add a zero buffer for separation
                gap = zeros(round(numSamples / 4), numElements);
                multiWV = [multiWV; gap; buf];
                waves_delay(i) = size(multiWV, 1) - size(buf, 1);
            else
                multiWV = buf;
                waves_delay(i) = 0;
            end
        end

        multiWaveforms(nacq).tot = multiWV;
        multiWaveforms(nacq).shifts = shift;
        multiWaveforms(nacq).waves_delay = waves_delay;
    end
end
