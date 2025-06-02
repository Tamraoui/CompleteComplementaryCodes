
% A Field II example that demonstrate the ACF and CCF correlation
% properties of CCC code.
% No noise was simulated 
% Change Field II path to you own and run the scirpt
% It just a single scatterer it will run fast ;)

clc;clear;close all
addpath('C:\Field_II\');
addpath("DAS\");
addpath('functions\')
field_init(-1);
num_elements = 128;       
f0=5e6;
c = 1540;                   % Speed of sound in tissue [m/s]
lambda = c / f0;            % Wavelength [m]
element_width=0.292/1000;   %  Width of element
kerf=0.155e-4; 
pitch=kerf+element_width;
element_height = 5e-3;      % Height of each element [m]
focus = [0 0 50];           % Fixed focus at 50 mm depth
fs=100e6;
set_sampling(fs);

% Create linear array transducer
xmit_aperture = xdc_linear_array(num_elements, element_width, element_height, kerf, 1, 1, focus);
receive_aperture = xdc_linear_array(num_elements, element_width, element_height, kerf, 1, 1, focus);

% Set impulse response of the transducer (Gaussian-modulated sine wave)
impulse_response = sin(2 * pi * f0 * (0:1/fs:2/f0)) .* hanning(length((0:1/fs:2/f0)))';
xdc_impulse(xmit_aperture, impulse_response);
xdc_impulse(receive_aperture, impulse_response);

xdc_times_focus(xmit_aperture, 0, zeros(1, num_elements)); % No focusing
xdc_times_focus(receive_aperture, 0, zeros(1, num_elements));

% element position
centers=xdc_get(xmit_aperture,'rect');
centers=centers(24:26,:)';



na=4;
if(na==2)
    angles=(-1:2:1);
elseif(na==4)
    angles=(-3:2:3);
elseif(na==8)
    angles=(-7:2:7);
end

M=2;N=na;L=4;
excitation = sin(2 * pi * f0 * (0:1/fs:1/f0));
[ccc_waveforms,~]=npComplementrayCodes(excitation,M,N,L,1);
[ ccc_data  ] = genMWPI3Cwaveforms(ccc_waveforms, angles, centers(:,1)' ,fs , c);



positions=[0 0 30]/1000;
amplitudes=1;

for i=1:na
    ele_waveform(xmit_aperture,[1:num_elements]',ccc_data(i).tot')
    [rf_data,t0]=calc_scat_multi(xmit_aperture,receive_aperture,positions,amplitudes);
    pwi_data{i}=rf_data;
    start_times(i)=t0;
end
figure;
subplot(221); imagesc(pwi_data{1}); title("RF DATA TX 1");
subplot(222); imagesc(pwi_data{2}); title("RF DATA TX 2");
subplot(223); imagesc(pwi_data{3}); title("RF DATA TX 3");
subplot(224); imagesc(pwi_data{4}); title("RF DATA TX 4");

% Pulse compensation time
pulse = abs(hilbert(conv(impulse_response,impulse_response)));
[~,id]=max(pulse);
t_comp=id/fs;
% used to calculate the length of the excitation waveform after decoding
excitation=ccc_waveforms{1}(1,:);
    
roi = ImageGrid();
roi.set_x_axis(linspace(-20e-3,20e-3,512).');
roi.set_z_axis(linspace(15e-3,55e-3,512).');
wave_delay=ccc_data(1).waves_delay/fs; %delay for each quasi transmitted plane wave 

% Make RF data hav the same size : zeros padding in the buttom
pwi_data=resize_cell(pwi_data);
rf_decoded=cell(1,na);
for nacq = 1: na
     rf=0;
    for i = 1:na
        rf=rf+conv2(pwi_data{i},flip(ccc_waveforms{nacq}(i,:)'));
    end
    rf_decoded{nacq}=rf;
end



figure;
subplot(221); imagesc(rf_decoded{1}); title("DECODED RF DATA PW 1");
subplot(222); imagesc(rf_decoded{2}); title("DECODED RF DATA PW 2");
subplot(223); imagesc(rf_decoded{3}); title("DECODED RF DATA PW 3");
subplot(224); imagesc(rf_decoded{4}); title("DECODED RF DATA PW 4");

% Reshape decoded data into a matrix for beamforming
rf_decoded=[rf_decoded{:}];
rf_decoded=reshape(rf_decoded,[],num_elements,na);


%--- Beamform
roi = ImageGrid();
roi.set_x_axis(linspace(-18e-3,18e-3,256).');
roi.set_z_axis(linspace(10e-3,50e-3,512).');

%--- No Tx apodization
tx_apo = [];
m_RxApod=Apodization();
m_RxApod.set_elements_positions(centers);
m_RxApod.set_f_number(.5);
m_RxApod.set_window('rect');
m_RxApod.set_focus(roi);
rx_apo = m_RxApod.get_data();

%--- beamforming parameters
params.fs=fs;
params.fc=f0;
params.f0=f0;
params.c=c;
params.modulation_frequency=f0;
params.initial_time=t0-t_comp-(numel(excitation))/fs;;
params.tx_centers=centers;
params.rx_centers=centers;
params.lambda=lambda;
params.azimuth_angles=deg2rad(angles);
params.elevation_angles=zeros(1,na);
params.N_elements=num_elements; ...
params.pitch=pitch;
params.start_times=wave_delay;

% The Das object
m_das = DAS(3,'PWI');
b_data=m_das.run(rf_decoded,roi,tx_apo,rx_apo,params);
b_data=reshape(squeeze(b_data),roi.N_z_axis,roi.N_x_axis);


env=abs(b_data);
x_axis=roi.x_axis;
z_axis=roi.z_axis;

figure;
imagesc(x_axis*1000,z_axis*1000,20*log10(env/max(env(:))),[-60 0])
colormap turbo
axis image
xlabel('Lateral [mm]','Interpreter','latex','FontSize',13)
ylabel('Axial [mm]','Interpreter','latex','FontSize',13)