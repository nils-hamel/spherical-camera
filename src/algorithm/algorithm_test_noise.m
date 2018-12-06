
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

    % @brief Test function : noise resistance
    %
    % This function allows to determine how the precision of the estimated
    % rotation and translation behave as noise is added to the projection of
    % the features on the two considered cameras.
    %
    % The amplitude of the noise is modulated from zero to two times the size
    % of the translation between the two randomly placed cameras. A random
    % scene is considered each time. For each noise amplitude, 'sc_amount' of
    % pose estimation are made to determine each time the error mean and
    % standard deviation.
    %
    % The function creates two plots showing the error mean and standard
    % deviation according to the noise amplitude : the first one for the error
    % on rotation and the second for the error on translation.
    %
    % @param sc_count  Number of features to consider
    % @param sc_amount Number of measures for each noise amplitude
    % @param sc_output Plots exportation path

    function algorithm_test_noise( sc_count, sc_amount, sc_output )

        % compose noise amplitude array %
        sc_noise = linspace( 0.0, 2.0, 32 );

        % reset plot array %
        sc_rot = zeros( length( sc_noise ), 2 );

        % reset plot array %
        sc_tra = zeros( length( sc_noise ), 2 );

        % parsing noise amplitude %
        for sc_amplitude = 1 : length( sc_noise )

            % reset measure array %
            sc_measure_rot = zeros( sc_amount, 1 );

            % reset measure array %
            sc_measure_tra = zeros( sc_amount, 1 );

            % measures loop %
            for sc_measure = 1 : sc_amount

                % create scene %
                sc_scene = algorithm_scene( zeros(1,3), 10, sc_count, false );

                % create camera center %
                sc_camac = ( rand(1,3) - 0.5 ) * 5;
                sc_cambc = ( rand(1,3) - 0.5 ) * 5;

                % compute translation %
                sc_trans = norm( sc_camac - sc_cambc );

                % create camera rotation %
                sc_camar = algorithm_randrot();
                sc_cambr = algorithm_randrot();

                % adding noise to scene %
                sc_scene_na = sc_scene; + ( rand( sc_count, 3 ) - 0.5 ) * sc_noise( sc_amplitude ) * sc_trans;
                sc_scene_nb = sc_scene; + ( rand( sc_count, 3 ) - 0.5 ) * sc_noise( sc_amplitude ) * sc_trans;

                % compute directions - features %
                sc_camad = algorithm_project( sc_camac, sc_camar, sc_scene_na );
                sc_cambd = algorithm_project( sc_cambc, sc_cambr, sc_scene_nb );

                % compute camera pose %
                [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db, sc_err_rad, sc_err_r, sc_err_t ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

                % iteration count %
                sc_iter = length( sc_err_rad );

                % true rotation %
                sc_r_ = sc_cambr * sc_camar';

                % true translation %
                sc_t_ = sc_cambr * ( sc_cambc - sc_camac )';

                % compute error on rotation %
                sc_measure_rot( sc_measure ) = norm( sc_err_r{end} * sc_r_' - eye(3) , 'fro' );

                % compute error on translation %
                sc_measure_tra( sc_measure ) = 1 - abs( dot( ( sc_err_t{end} / norm( sc_err_t{end} ) ), ( sc_t_ / norm( sc_t_ ) ) ) );

            end

            % assign plot value %
            sc_rot( sc_amplitude, 1 ) = mean( sc_measure_rot );

            % assign plot value %
            sc_rot( sc_amplitude, 2 ) = std( sc_measure_rot );

            % assign plot value %
            sc_tra( sc_amplitude, 1 ) = mean( sc_measure_tra );

            % assign plot value %
            sc_tra( sc_amplitude, 2 ) = std( sc_measure_tra );

        end

        % create figure %
        figure;

        % figure configuration %
        hold on;
        grid on;
        box  on;

        % display area plot %
        sc_a = area( sc_noise, [ sc_rot(:,1) - sc_rot(:,2) * 0.5, sc_rot(:,2) ], 'EdgeColor', 'None' );

        % assign area color %
        set( sc_a(1), 'FaceColor', 'None' );
        set( sc_a(2), 'FaceColor', [ 255 202 103 ] / 255 );

        % display mean plot %
        plot( sc_noise, sc_rot(:,1), '-', 'linewidth', 2, 'Color', [ 255 187 61 ] / 255 );

        % axis label %
        xlabel( '| T | factor' );
        ylabel( 'Error' );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/noise_rot.png' ] );

        % create figure %
        figure;

        % figure configuration %
        hold on;
        grid on;
        box  on;

        % display area plot %
        sc_a = area( sc_noise, [ sc_tra(:,1) - sc_tra(:,2) * 0.5, sc_tra(:,2) ], 'EdgeColor', 'None' );

        % assign area color %
        set( sc_a(1), 'FaceColor', 'None' );
        set( sc_a(2), 'FaceColor', [ 255 202 103 ] / 255 );

        % display mean plot %
        plot( sc_noise, sc_tra(:,1), '-', 'linewidth', 2, 'Color', [ 255 187 61 ] / 255 );

        % axis label %
        xlabel( '| T | factor' );
        ylabel( 'Error' );

        % export figure %
        print( '-dpng', '-r300', [ sc_output '/noise_tra.png' ] );

    end

