
    %  spherical-camera
    %
    %      Nils Hamel - nils.hamel@bluewin.ch
    %      Copyright (c) 2016-2018 DHLAB, EPFL
    %
    %  This program is free software: you can redistribute it and/or modify
    %  it under the terms of the GNU General Public License as published by
    %  the Free Software Foundation, either version 3 of the License, or
    %  (at your option) any later version.
    %
    %  This program is distributed in the hope that it will be useful,
    %  but WITHOUT ANY WARRANTY; without even the implied warranty of
    %  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %  GNU General Public License for more details.
    %
    %  You should have received a copy of the GNU General Public License
    %  along with this program.  If not, see <http://www.gnu.org/licenses/>.

    function algorithm_test_fov( sc_count, sc_amount, sc_output )

        % radius of the scene %
        sc_radius = 10.0;

        % create filled scene %
        sc_scene = algorithm_scene( zeros(1,3), sc_radius, sc_count, false );

        % create camera positions %
        sc_position = logspace( 0, log( sc_radius * 5.0 ) / log( 10.0 ), 16 );

        % compute corresponding angles %
        sc_angle = algorithm_test_fov_angle( sc_position, sc_radius, 0.01 ) * ( 180.0 / pi );

        % parsing positions %
        for sc_i = 1 : length( sc_position )

            % reset accumulation arrays %
            sc_acc_r = [];
            sc_acc_t = [];

            % parsing measures %
            for sc_j = 1 : sc_amount

                % create scene %
                sc_scene = algorithm_scene( zeros(1,3), 10, sc_count, false );

                % create camera rotation %
                sc_camar = eye(3);
                sc_cambr = eye(3);

                % create camera center %
                sc_camac = [ +sc_position( sc_i ), 0, 0 ];
                sc_cambc = [ -sc_position( sc_i ), 0, 0 ];

                % compute directions - features %
                sc_camad = algorithm_project( sc_camac, sc_camar, sc_scene );
                sc_cambd = algorithm_project( sc_cambc, sc_cambr, sc_scene );

                % compute camera pose %
                [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db, sc_err_rad ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

                % true rotation %
                sc_r_ = sc_cambr * sc_camar';

                % true translation %
                sc_t_ = sc_cambr * ( sc_cambc - sc_camac )';

                % compute error on rotation %
                sc_r_err = norm( sc_r * sc_r_' - eye(3) , 'fro' );

                % compute error on translation %
                sc_t_err = 1 - abs( dot( ( sc_t / norm( sc_t ) ), ( sc_t_ / norm( sc_t_ ) ) ) );

                % accumulate error on rotation %
                sc_acc_r(sc_j) = sc_r_err;

                % accumulate error on tranlsation %
                sc_acc_t(sc_j) = sc_t_err;

            end

            % compute rotation error mean %
            sc_r_mean(sc_i) = mean( sc_acc_r );

            % compute rotation error standard deviation %
            sc_r_std (sc_i) = std ( sc_acc_r );

            % compute translation error mean %
            sc_t_mean(sc_i) = mean( sc_acc_t );

            % compute translation error standard deviation %
            sc_t_std (sc_i) = std ( sc_acc_t );

        end

        % create figure %
        figure;

        % figure configuration %
        hold on;
        grid on;
        box  on;

        % display error standard deviation %
        sc_a = area( sc_angle, [ sc_r_mean' - sc_r_std' * 0.5, sc_r_std' ], 'EdgeColor', 'None' );

        % assign error standard deviation color %
        set( sc_a(1), 'FaceColor', 'None' );
        set( sc_a(2), 'FaceColor', [ 255 202 103 ] / 255 );

        % display error mean %
        plot( sc_angle, sc_r_mean, '-', 'linewidth', 2, 'Color', [ 255 187 61 ] / 255 );

        % axis label %
        xlabel( 'Angles [°]' );
        ylabel( 'Rotation error' );

        % axis configuration %
        xlim( [ 0 360 ] );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/field-rotation.png' ] );

        % create figure %
        figure;

        % figure configuration %
        hold on;
        grid on;
        box  on;

        % display error standard deviation %
        sc_a = area( sc_angle, [ sc_t_mean' - sc_t_std' * 0.5, sc_t_std' ], 'EdgeColor', 'None' );

        % assign error standard deviation color %
        set( sc_a(1), 'FaceColor', 'None' );
        set( sc_a(2), 'FaceColor', [ 255 202 103 ] / 255 );

        % display error mean %
        plot( sc_angle, sc_t_mean, '-', 'linewidth', 2, 'Color', [ 255 187 61 ] / 255 );

        % axis label %
        xlabel( 'Angles [°]' );
        ylabel( 'Translation error' );

        % axis configuration %
        xlim( [ 0 360 ] );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/field-translation.png' ] );

    end

    function sc_angle = algorithm_test_fov_angle( sc_d, sc_r, sc_gamma )

        % parsing distances %
        for sc_i = 1 : length( sc_d )

            % check domain %
            if ( sc_d(sc_i) > sc_r )

                % compute angle %
                sc_angle(sc_i) = 2.0 * asin( sc_r / sc_d(sc_i) );

            else

                % compute parameter %
                sc_param = sc_r - sc_d(sc_i);

                % compute angle %
                sc_angle(sc_i) = 2.0 * ( pi - atan( ( sc_gamma * pi * sc_r * sc_r ) / ( sc_param * sc_param ) ) );

            end

        end

    end

