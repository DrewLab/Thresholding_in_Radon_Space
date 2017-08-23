function [area, radoncontours]=PenetratingVesselDiameterTiff_theDemo(thefile, maxframe)
% this function impliments the "Thresholded in Radon Space" (TiRS)
% algorithm described in Gao and Drew, Journal of Cerebral Blood Flow and
% Metabolism, 2014 (DOI:10.1038/jcbfm.2014.67)
% This code works on a movie (in .tif stack form) of a penetrating vessel
%
% INPUTS:
% thefile - string containing the name of the .tif stack to be used
% maxframe - last frame to be analyzed
% OUTPUTS:
% area - area of vessel
% radoncontours - contour lines drawn at the trheshold in the inverse-Radon
% transformed image
%
% Once the first frame of the movie is displayed the user is asked to draw
% a selsection box around the the vessel.  The box should have dimensions
% ~2-3x greater than the vessel, and there should be no other extraneous
% fluorescent objects (capillaries, neurons, etc.) within it.  The
% algorithm is robust to minor x-y translational movements.
% Patrick Drew, pjd17@psu.edu, 8/2017

thefile_info=imfinfo(thefile);% the name of the file to be loaded
nframes=length(thefile_info);% number of frames in file
the_angles=1:1:180;
rtd_threhold=.5;%. threshold in radon space, typically between 0.35 to 0.5
irtd_threhold=.2;%.threshold for converting back using inverse Radon transform, typically 0.2
area=-ones(min(nframes,maxframe),1); % area of vessel cross-section
radoncontours=cell(min(nframes,maxframe),1); %countour lines obtained of the vessel lumen using TiRS method

%displays the first frame of the .tif stack and asks the user to draw a box
%around the penetrating vessel

figure(77)
% display the first frame of the .tif stack so the user can draw a box around the vessel
imagesc(imread(thefile,'tif', 'Index',1))
colormap gray
axis image
title('draw a box around region to be processed')
thebox=imrect(gca);
theinput=input('type enter when done','s');

api = iptgetapi(thebox);
mv_mpP(1).Vessel.box_position.xy=api.getPosition();


for f=1:min(nframes,maxframe)
    %read in the image in the tiff stack and converti it into a double for procesing
    raw_hold_image=double(sum(imread(thefile,'tif', 'Index',f),3));
    hold_image=raw_hold_image(round(mv_mpP(1).Vessel.box_position.xy(2):mv_mpP(1).Vessel.box_position.xy(2)+mv_mpP(1).Vessel.box_position.xy(4)),...
        round(mv_mpP(1).Vessel.box_position.xy(1):mv_mpP(1).Vessel.box_position.xy(1)+mv_mpP(1).Vessel.box_position.xy(3)));
    radon_hold_image=radon(hold_image,the_angles);
    for k=1:length(the_angles)
        % for each angle, rescale the image intensity to 0 to 1.
        radon_hold_image(:,k)=radon_hold_image(:,k)-min(radon_hold_image(:,k));
        radon_hold_image(:,k)=radon_hold_image(:,k)/max(radon_hold_image(:,k));
        [maxpoint(k),maxpointlocation(k)]=max(radon_hold_image(:,k));
        
        % find the threshold crossings in Radon Space
        [~,min_edge(k)]=max(find(radon_hold_image(1:maxpointlocation(k),k)<rtd_threhold));
        [~,max_edge(k)]=max(find(radon_hold_image(maxpointlocation(k)+1:end,k)>rtd_threhold));
        % set all other pixels to 0
        radon_hold_image(1:min_edge(k),k)=0;
        radon_hold_image((maxpointlocation(k)+max_edge(k)):end,k)=0;
    end
    %transform the image that has been threholded in Radon space back to
    %image space
    irtd_norm=iradon(double(radon_hold_image>rtd_threhold*max(radon_hold_image(:))),(the_angles),'linear','Hamming',size(radon_hold_image,2));
    
    %threshold the image
    [cc,l]=bwboundaries(irtd_norm>irtd_threhold*max(irtd_norm(:)));
    numPixels = cellfun(@length,cc);
    %find the largest contiguous group of suprathreshold pixels
    [~,idx] = max(numPixels);
    figure(44)
    
    subplot(221)
    hold off
    
    imagesc(hold_image,'XData',[1:size(hold_image,2)]+90-size(hold_image,2)/2,'YData',[1:size(hold_image,1)]+90-size(hold_image,1)/2)
    axis([min([1:size(hold_image,2)]+90-size(hold_image,2)/2) max([1:size(hold_image,2)]+90-size(hold_image,2)/2)...
        min([1:size(hold_image,1)]+90-size(hold_image,1)/2) max([1:size(hold_image,1)]+90-size(hold_image,1)/2)])
    axis equal
    
    axis xy
    hold on
    colormap gray
    
    title(['frame=' num2str(f)])
    subplot(222)
    imagesc(irtd_norm)
    axis image
    axis xy
    title('inverse-Radon transformed image')
    
    area_filled=regionprops(l,'FilledArea','Image','FilledImage');
    area(f)=length(find(area_filled(idx).FilledImage));
    subplot(221)
    radoncontours{f}=contour(irtd_norm(1:end,1:end),[irtd_threhold irtd_threhold]*max(irtd_norm(:)),'r', 'LineWidth', 2);
    pause(0.05)
end

%plot the area for each frame
subplot(2,1,2)
plot(1:f,area(1:f),'ro')
xlabel('frame number')
ylabel('area, pixels')
ylim([0 1.2*max(area(1:f))])

