
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

    function [ sc_da, sc_db ] = algorithm_data( sc_size, sc_match )

        % initialise memory %
        sc_da = zeros( size( sc_match, 1 ), 3 );

        % initialise memory %
        sc_db = zeros( size( sc_match, 1 ), 3 );

        % parsing matches %
        for sc_i = 1 : size( sc_match, 1 )

            % compute angles %
            sc_lon = ( ( sc_match( sc_i, 1 ) - 1 ) / sc_size( 1 ) ) * 2 * pi;

            % compute angle %
            sc_lat = ( 0.5 - ( sc_match( sc_i, 2 ) / sc_size( 2 ) ) ) * pi;

            % compute direction vector %
            sc_da( sc_i, 1 ) = cos( sc_lat ) * cos( sc_lon );
            sc_da( sc_i, 2 ) = cos( sc_lat ) * sin( sc_lon );
            sc_da( sc_i, 3 ) = sin( sc_lat );

            % compute angles %
            sc_lon = ( ( sc_match( sc_i, 3 ) - 1 ) / sc_size( 1 ) ) * 2 * pi;

            % compute angle %
            sc_lat = ( 0.5 - ( sc_match( sc_i, 4 ) / sc_size( 2 ) ) ) * pi;

            % compute direction vector %
            sc_db( sc_i, 1 ) = cos( sc_lat ) * cos( sc_lon );
            sc_db( sc_i, 2 ) = cos( sc_lat ) * sin( sc_lon );
            sc_db( sc_i, 3 ) = sin( sc_lat );

        end

    end
