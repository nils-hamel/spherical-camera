
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

    % @brief Test function : random estimation
    %
    % This function allows to set a random scene and camera position/orientation
    % and to compute the pose estimation. The results are display on terminal
    % and a plot of the last iteration is created and exported.
    %
    % @param sc_count  Number of features to consider
    % @param sc_output Plot exportation path

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
        [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

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
        algorithm_plot_scene( sc_da, sc_ra, sc_db, sc_rb, sc_r, sc_t, sc_output );

    end
