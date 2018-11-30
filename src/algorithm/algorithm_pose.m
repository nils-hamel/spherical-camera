
    function [ sc_r, sc_t, sc_ra, sc_rb, sc_err_rad, sc_err_r, sc_err_t ] = algorithm_pose( sc_da, sc_db, sc_tol )

        % initialise radii %
        sc_ra = ones( size( sc_da, 1 ), 1 );
        sc_rb = ones( size( sc_db, 1 ), 1 );

        % iteration control %
        sc_flag = true;

        % iteration condition %
        sc_icc = +0.0;
        sc_icp = -1.0;

        % iteration counter %
        sc_iter = 1;

        % pose estimation %
        while ( sc_flag == true )

            % compute camera features %
            sc_fa = algorithm_features( sc_ra, sc_da );

            % compute camera features %
            sc_fb = algorithm_features( sc_rb, sc_db );

            % compute registration transformation %
            [ sc_rr, sc_rt ] = algorithm_register( sc_fa, sc_fb );

            % rotate first point set on second camera frame %
            sc_dc = algorithm_rotate( sc_da, sc_rr );

            % compute radius correction %
            [ sc_ra, sc_rb ] = algorithm_radius( sc_rt', sc_dc, zeros( 1, 3 ), sc_db );

            % compute error %
            sc_icc = algorithm_error( sc_rt', sc_dc, sc_ra, zeros( 1, 3 ), sc_db, sc_rb );

            % compute iteration condition %
            if ( abs( sc_icc - sc_icp ) < sc_tol )

                % update iteration control %
                sc_flag = false;

            else

                % push previous error %
                sc_icp = sc_icc;

            end

            % display information %
            fprintf( 2, 'Iteration %i with %g remaining\n', sc_iter, sc_icc );

            % index error on radius %
            sc_err_rad( sc_iter ) = sc_icc;

            % index rotation matrix %
            sc_err_r{ sc_iter } = sc_rr;

            % index translation vector %
            sc_err_t{ sc_iter } = sc_rt;

            % update iteration counter %
            sc_iter = sc_iter + 1;

        end

        % return rotation matrix %
        sc_r = sc_rr;

        % return translation vector %
        sc_t = sc_rt;

    end
