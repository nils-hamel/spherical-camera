
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

    % @brief Test function : error convergence
    %
    % This function allows to analyse and plot the behaviour of the rotation and
    % translation error along with the pose estimation algorithm iteration.
    %
    % The function sets a random scene and two random camera position and
    % rotation before to apply the pose estimation algorithm on it. The true
    % rotation and translation being known, the error can be computed and plot.
    %
    % Two plots are created by the function : the first plot shows how the
    % maximum separation of estimated features positions evolve across the
    % iterations. The second plot shows how the rotation and translation error
    % behave along the algorithm iterations.
    %
    % @param sc_count  Number of scene points to consider
    % @param sc_output Plots exportation path

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
        [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db, sc_err_rad, sc_err_r, sc_err_t ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

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
            sc_err_tra( sc_i ) = abs( 1 - abs( dot( ( sc_err_t{sc_i} / norm( sc_err_t{sc_i} ) ), ( sc_t_ / norm( sc_t_ ) ) ) ) );

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

