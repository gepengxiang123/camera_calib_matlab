function test_refine_circle_points
    % Get tests path
    tests_path = fileparts(fileparts(fileparts(mfilename('fullpath'))));
    
    % Get circle points
    array_cb = rgb2gray(im2double(imread(fullfile(tests_path,'data','ellipse1.jpg'))));
    opts.height_fp = 550;
    opts.width_fp = 550;
    opts.num_targets_height = 25;
    opts.num_targets_width = 25;
    opts.target_spacing = 50;
    opts.refine_ellipse_edges_h2_init = 0.750000000000000;
    opts.refine_ellipse_edges_it_cutoff = 20;
    opts.refine_ellipse_edges_norm_cutoff = 1e-3;
    target_mat = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; ...
                  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    [p_cb_ps_test, cov_cb_ps_test, idx_valid_test] = alg.refine_circle_points(array_cb, ...
                                                                              @(p)(alg.apply_homography_p2p(p,1.0e+02 * [ 0.001754779252293   0.005921859775072  -0.312798683623242; ...
                                                                                                                         -0.004604166011831  -0.000017615811609   5.206069241794649; ...
                                                                                                                          0.000004425641058  -0.000000763171626   0.010000000000000])), ...
                                                                              opts, ...
                                                                              target_mat(:));
    
    %{
    % Plot example
    f = figure;
    imshow(array_cb,[]);
    hold on;
    plot(p_cb_ps_test(idx_valid_test,1),p_cb_ps_test(idx_valid_test,2),'gs');
    sf = 1e3;
    for i = 1:numel(cov_cb_ps_test)
        if idx_valid_test(i)
            e = alg.cov2ellipse(cov_cb_ps_test{i},p_cb_ps_test(i,:));
            external.ellipse(e(3)*sf,e(4)*sf,e(5),e(1),e(2),'r');
        end
    end
    pause(1);
    close(f);    
    %}
    
    % Assert
    load(fullfile(tests_path,'data','ellipse1_points.mat'));
    
    assert(all(all(abs(p_cb_ps - p_cb_ps_test) < 1e-4)));
    for i = 1:numel(cov_cb_ps_test)
        assert(all(all(abs(cov_cb_ps{i} - cov_cb_ps_test{i}) < 1e-4))); %#ok<IDISVAR,USENS>
    end
    assert(all(idx_valid  == idx_valid_test));
end