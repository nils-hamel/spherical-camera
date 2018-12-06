
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

    % @brief Test function : field of view
    %
    % This function implements an analysis of the behaviour of the rotation and
    % translation estimation precision according to the angle of view of the
    % camera.
    %
    % The experiments consist in two cameras placed in opposition with the scene
    % features in a sphere at the center. The cameras are moved from far away to
    % the center of the scene sphere. As the cameras are far away, the angle of
    % view with which the scene is seen is very narrow. As the cameras are
    % getting closer, the view angle increase until the cameras enter the scene
    % sphere toward its center.
    %
    % The angle of view is then identified to the cameras distance to the center
    % of the scene sphere : formally as the cameras are outside of the scene
    % sphere and more statistically as the cameras are inside.
    %
    % For each camera position, 'sc_amount' estimation are performed to obtain a
    % mean and standard deviation on the error.
    %
    % The function creates and exports two plots showing the evolution of the
    % error mean and the standard deviation according to the angle of view for
    % both rotation and translation.
    %
    % @param sc_count   Number of features to consider
    % @param sc_measure Number of angles of view to analyse
    % @param sc_amount  Number of measures for each angle of view
    % @param sc_output  Plots exportation path

    function algorithm_test_fov( sc_count, sc_measure, sc_amount, sc_output )

        % radius of the scene %
        sc_radius = 10.0;

        % create filled scene %
        sc_scene = algorithm_scene( zeros(1,3), sc_radius, sc_count, false );

        % create camera positions %
        sc_position = logspace( log( sc_radius * 0.5 ) / log( 10 ), log( sc_radius * 5.0 ) / log( 10.0 ), sc_measure );

        % compute corresponding angles %
        sc_angle = algorithm_test_fov_angle( sc_position, sc_radius, 0.01 ) * ( 180.0 / pi );

        % parsing positions %
        for sc_i = 1 : sc_measure

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

                % accumulate error on translation %
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

        % retrieve limit %
        sc_yl = ylim;

        % display indication : 36x24mm 35mm -> 63.4° %
        plot( 63.4 * ones(2,1), sc_yl, '-', 'linewidth', 2, 'Color', [ 36 131 255 ] / 255 );

        % display indication : 36x24mm 24mm -> 84.1° %
        plot( 84.1 * ones(2,1), sc_yl, '-', 'linewidth', 2, 'Color', [ 0 78 178 ] / 255 );

        % display indication : 180° %
        plot( 180. * ones(2,1), sc_yl, '-', 'linewidth', 2, 'Color', [ 0.7 0.7 0.7 ] );

        % axis label %
        xlabel( 'Angles [Degrees]' );
        ylabel( 'Rotation error' );

        % axis configuration %
        axis( [ 0, 360, sc_yl ] );

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

        % retrieve limit %
        sc_yl = ylim;

        % display indication : 36x24mm 35mm -> 63.4° %
        plot( 63.4 * ones(2,1), sc_yl, '-', 'linewidth', 2, 'Color', [ 36 131 255 ] / 255 );

        % display indication : 36x24mm 24mm -> 84.1° %
        plot( 84.1 * ones(2,1), sc_yl, '-', 'linewidth', 2, 'Color', [ 0 78 178 ] / 255 );

        % display indication : 180° %
        plot( 180. * ones(2,1), sc_yl, '-', 'linewidth', 2, 'Color', [ 0.7 0.7 0.7 ] );

        % axis label %
        xlabel( 'Angles [Degrees]' );
        ylabel( 'Translation error' );

        % axis configuration %
        axis( [ 0, 360, sc_yl ] );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/field-translation.png' ] );

    end

    % @brief Angle according to camera distance to scene center
    %
    % This function gives an estimation of the angle of view of the camera
    % according to its distance to the center of the scene sphere.
    %
    % As the camera is outside of the scene sphere, the angle of view is easy
    % to determine.
    %
    % As the camera is inside the scene sphere, a statistical model is applied
    % to deduce an value for the angle of view. The angle is deduced from the
    % aperture of the camera rear cone to remove to obtain a probability of
    % one minus 'sc_gamma' to find a scene point in the rest of the scene.
    %
    % @param sc_d      Camera distances
    % @param sc_r      Scene sphere radius
    % @param sc_gamma  Probability value
    %
    % @return sc_angle Angles according to distances

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

