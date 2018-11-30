
    function algorithm_test_random( sc_count, sc_output )

        % create scene %
        sc_scene = algorithm_scene( zeros(1,3), 10, sc_count, false );

        % create camera center %
        sc_camac = ( rand(1,3) - 0.5 ) * 5
        sc_cambc = ( rand(1,3) - 0.5 ) * 5

        % create camera rotation %
        sc_camar = algorithm_randrot();
        sc_cambr = algorithm_randrot();

        % compute directions - features %
        sc_camad = algorithm_project( sc_camac, sc_camar, sc_scene );
        sc_cambd = algorithm_project( sc_cambc, sc_cambr, sc_scene );

        % compute camera pose %
        [ sc_r, sc_t, sc_ra, sc_rb ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

        % true rotation %
        sc_r_ = sc_cambr * sc_camar';

        % true translation %
        sc_t_ = sc_cambr * ( sc_cambc - sc_camac )';

        % compute error on rotation %
        sc_r_err = norm( sc_r * sc_r_' - eye(3) , 'fro' );

        % compute error on translation %
        sc_t_err = 1 - abs( dot( ( sc_t / norm( sc_t ) ), ( sc_t_ / norm( sc_t_ ) ) ) );

        % display results %
        printf( 'error on rotation : %g and translation : %g\n', sc_r_err, sc_t_err );

        % display configuration %
        algorithm_plot_scene( sc_camad, sc_ra, sc_cambd, sc_rb, sc_r, sc_t, sc_output );

    end
