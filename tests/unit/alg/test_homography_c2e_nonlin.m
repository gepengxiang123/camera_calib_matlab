function test_homography_c2e_nonlin
    p_1s = [0 0;
            0 1;
            1 0;
            1 1];

    p_2s = [0.453153153153153   0.115888615888616;
            0.544135802469135   0.683641975308643;
            1.339606396063960  -0.212915129151290;
            1.410502283105022   0.510958904109590];

    % Ground truth
    H_12 = [ 0.486486486486487   0.105405405405405   0.100000000000000;
            -0.216216216216216   0.521621621621622   0.300000000000000;
            -0.162162162162162   0.027027027027027   1.000000000000000];

    % Assert
    opts.homography_c2e_it_cutoff = 20;
    opts.homography_c2e_norm_cutoff = 1e-6;
    r_1 = 2;
    assert(all(all(abs(alg.homography_c2e_nonlin(p_1s, p_2s, round(H_12, 1), r_1, opts) - H_12) < 1e-4)));
end
