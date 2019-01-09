
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

    % @brief Test function : real case application
    %
    % This function allows to computes the pose estimation between two real case
    % images using a set of matches extracted from the images. The computed
    % rotation and translation displayed in the terminal. In addition, a plot
    % of the final iteration is displayed and exported using the provided
    % output path.
    %
    % The matches are expected to be provided through the data array pointed by
    % the provided path. The two first number of the file are interpreted as the
    % width and height of the image from which features have been extracted and
    % matched. The rest of the data file is interpreted as a N by 4 array that
    % gives the x and y coordinates of each matched features (x1,y1,x2,y2).
    %
    % @param sc_count  Data file path
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
