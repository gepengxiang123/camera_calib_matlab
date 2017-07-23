%% Clear
clear, clc;
f1 = figure(1);

%% Set images
cb_img_paths = {'test_images/Image1.tif', ...
                'test_images/Image2.tif', ...
                'test_images/Image3.tif'};
                     
% Validate all calibration board images
cb_imgs = class.img.validate_similar_imgs(cb_img_paths);
                     
%% Load calibration board config file
cb_config = util.load_cb_config('board_zhang.yaml');

% Debug
debug.plot_cb_config(cb_config,subplot(2,2,1,'parent',f1));

%% Get four points in image coordinates per calibration board image
four_points_is = {};
switch cb_config.calibration
    case 'four_point_auto'
        error('Automatic four point detection has not been implemented yet');
    case 'four_point_manual'
        % Four points are selected manually
        [~, four_points_w] = alg.cb_points(cb_config);

        % Board 1 
        four_points_is{1} = [168 179;
                             135 376;
                             415 194;
                             472 385];
                                     
        % Board 2 
        four_points_is{2} = [173 106;
                             138 378;
                             443 127;
                             481 389];
                         
        % Board 3 
        four_points_is{3} = [199 97;
                             117 354;
                             472 142;
                             461 412]; 
                         
        % Refine
        for i = 1:length(four_points_is)
            four_points_is{i} = alg.refine_points(four_points_is{i}, ...
                                                  cb_imgs(i), ...
                                                  alg.homography(four_points_w,four_points_is{i},cb_config), ...
                                                  cb_config); 
          
            debug.plot_cb_refine_points(four_points_is{i}, ...
                                        cb_imgs(i), ...
                                        alg.homography(four_points_w,four_points_is{i},cb_config), ...
                                        cb_config, ...
                                        subplot(2,2,i+1,'parent',f1));
        end   
end

%% Perform zhang calibration
[A,distortion,rotations,translations,board_points_is] = alg.single_calibrate(cb_imgs, ...
                                                                             four_points_is, ...
                                                                             cb_config);

% Debug by reprojecting points
f2 = figure(2);
for i = 1:length(cb_imgs)
    debug.plot_cb_points_disp(alg.apply_full_model(A,distortion,rotations{i},translations{i},alg.cb_points(cb_config)), ...
                              board_points_is{i}, ...
                              cb_imgs(i), ...
                              subplot(3,3,i+1,'parent',f2));
end