
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

    % @breif Test function : random estimation
    %
    % This function allows to set a random scene and camera position/orientation
    % and to compute the pose estimation. The results are display on terminal
    % and a plot of the last iteration is created and exported.
    %
    % @param sc_count  Number of features to consider
    % @param sc_output Plot exportation path

    function algorithm_test_data( sc_filepath, sc_output )

        % create input stream %
        sc_stream = fopen( sc_filepath );

        % import data header %
        sc_size = fscanf( sc_stream, '%i', 2 );

        % import data matches %
        sc_data = fscanf( sc_stream, '%f', [ 4, inf ] )';

        % delete input stream %
        fclose( sc_stream );

        % compute direction vectors %
        [ sc_camad, sc_cambd ] = algorithm_data( sc_size, sc_data );

        % compute camera pose %
        [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

        % display rotation %
        display( sc_r );

        % display tranlsation %
        display( sc_t );

        % display configuration %
        algorithm_plot_scene( sc_da, sc_ra, sc_db, sc_rb, sc_r, sc_t, sc_output );

    end
