function save_calib(calib, file_path)
    % Saves a calibration to file path
    %
    % Inputs:
    %   calib - struct; calibration
    %   file_path - string; path to save calibration
    %
    % Outputs:
    %   none

    % This will clear the file
    fclose(fopen(file_path, 'w'));

    % Write config
    util.write_comment('Calibration configuration', file_path);
    util.write_data(calib.config, file_path);
    util.write_newline(file_path);

    % Write each cameras calibration
    for i = 1:numel(calib.cam)
        util.write_single_cam(calib.cam(i), file_path, ['_cam' num2str(i)]);
    end
end
