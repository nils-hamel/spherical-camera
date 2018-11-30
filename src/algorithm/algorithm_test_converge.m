
    function algorithm_test_converge( sc_count, sc_output )

        % create scene %
        sc_scene = algorithm_scene( zeros(1,3), 10, sc_count, false );

        % create camera center %
        sc_camac = ( rand(1,3) - 0.5 ) * 5;
        sc_cambc = ( rand(1,3) - 0.5 ) * 5;

        % create camera rotation %
        sc_camar = algorithm_randrot();
        sc_cambr = algorithm_randrot();

        % compute directions - features %
        sc_camad = algorithm_project( sc_camac, sc_camar, sc_scene );
        sc_cambd = algorithm_project( sc_cambc, sc_cambr, sc_scene );

        % compute camera pose %
        [ sc_r, sc_t, sc_ra, sc_rb, sc_err_rad, sc_err_r, sc_err_t ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

        % iteration count %
        sc_iter = length( sc_err_rad );

        % true rotation %
        sc_r_ = sc_cambr * sc_camar';

        % true translation %
        sc_t_ = sc_cambr * ( sc_cambc - sc_camac )';

        % create figure %
        figure;

        % figure configuration %
        hold on;
        grid on;
        box  on;

        % display error %
        semilogy( [1:sc_iter], sc_err_rad, '-', 'color', [255 187 61]/255, 'linewidth', 2 );

        % axis labels %
        xlabel( 'Iteration' );
        ylabel( 'max | separation |' );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/sep-error.png' ] );

        % compute error on rotation and translation %
        for sc_i = 1 : sc_iter

            % compute error on rotation %
            sc_err_rot( sc_i ) = norm( sc_err_r{sc_i} * sc_r_' - eye(3) , 'fro' );

            % compute error on translation %
            sc_err_tra( sc_i ) = 1 - abs( dot( ( sc_err_t{sc_i} / norm( sc_err_t{sc_i} ) ), ( sc_t_ / norm( sc_t_ ) ) ) );

        end

        % create figure %
        figure;

        % figure configuration %
        hold on;
        grid on;
        box  on;

        % display error %
        semilogy( [1:sc_iter], sc_err_rot, '-', 'color', [255 187 61]/255, 'linewidth', 2 );

        % display error %
        semilogy( [1:sc_iter], sc_err_tra, '-', 'color', [36 131 255]/255, 'linewidth', 2 );

        % axis labels %
        xlabel( 'Iteration' );
        ylabel( 'error' );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/pose-error.png' ] );

    end