
    %  spherical-camera
    %
    %      Nils Hamel - nils.hamel@bluewin.ch
    %      Copyright (c) 2016-2020 DHLAB, EPFL
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

    % @brief Cameras radii correction
    %
    % This function considers the provided features direction unitary vectors
    % and camera centers to compute their respective best intersections in the
    % 3D space. The intersection is then used to correct the values of the radii
    % to make them corresponds to this optimal intersection through an orthogonal
    % projection.
    %
    % The cameras radii and directions are expected to be expressed in the frame
    % of one of the camera, taking into account the estimated rotation matrix
    % and translation vector between the camera.
    %
    % @param sc_ca First camera position
    % @param sc_da First camera features direction unitary vector
    % @param sc_ca Second camera position
    % @param sc_da Second camera features direction unitary vector
    %
    % @param sc_ra First camera corrected radii
    % @param sc_rb Second camera corrected radii

    function [ sc_ra, sc_rb ] = algorithm_radius( sc_ca, sc_da, sc_cb, sc_db )

        % initialise memory %
        sc_ra = zeros( size( sc_da, 1 ), 1 );
        sc_rb = zeros( size( sc_db, 1 ), 1 );

        % parsing radius %
        for sc_i = 1 : size( sc_da, 1 )

            % compute radius correction %
            [ sc_ra(sc_i), sc_rb(sc_i) ] = algorithm_intersect( sc_ca, sc_da(sc_i,:), sc_cb, sc_db(sc_i,:) );

        end

    end
