function test_grad_array
    array = [0 0 0;
             0 1 0;
             0 0 0];

    % Assert
    assert(all(all(abs(alg.grad_array(array,'x') - [0.125000000000000                   0  -0.125000000000000;
                                                    0.250000000000000                   0  -0.250000000000000;
                                                    0.125000000000000                   0  -0.125000000000000]) < 1e-4)))
    assert(all(all(abs(alg.grad_array(array,'y') - [0.125000000000000   0.250000000000000   0.125000000000000;
                                                                    0                   0                   0;
                                                   -0.125000000000000  -0.250000000000000  -0.125000000000000]) < 1e-4)))
end
