
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

    % @brief 3D line intersection estimation
    %
    % This function computes the best intersection of the two 3D lines provided
    % as parameters. The first parameter has to gives the center of the first
    % camera (position), the second gives the direction vector of the first line,
    % the third the center of the second camera while the last parameter gives
    % the direction vector of the second line.
    %
    % The function expects both line parameter to be expressed in the same frame,
    % that is either : the first line expressed in the frame of the second
    % camera or the second line expressed in the frame of the first camera.
    %
    % The best intersection is here understood as the middle point of the
    % orthogonal segment joining the two line (which is unique).
    %
    % The function computes then the best radii according to the center of the
    % two camera and to the intersection segment. The new radii are understood
    % as the distance that separates the center of the camera to the intersection
    % of the line with the best intersection orthogonal segment.
    %
    % The computed radii are returned by the function for each of the two lines.
    %
    % @param sc_ca First camera center
    % @param sc_da First camera line direction
    % @param sc_cb Second camera center
    % @param sc_db Second camera line direction
    %
    % @return sc_ra Computed radius for the first camera
    % @return sc_rb Computed radius for the second camera

    function [ sc_ra, sc_rb ] = algorithm_intersect( sc_ca, sc_da, sc_cb, sc_db )

        % compute temporary vector %
        sc_ab = sc_cb - sc_ca;

        % compute temporary factors %
        sc_spaa = dot( sc_da, sc_da );
        sc_spbb = dot( sc_db, sc_db );
        sc_spab = dot( sc_da, sc_db );
        sc_spac = dot( sc_da, sc_ab );
        sc_spbc = dot( sc_db, sc_ab );

        % compute temporary common denominator %
        sc_den = sc_spaa * sc_spbb - sc_spab * sc_spab;

        % compute first radius %
        sc_ra = ( - sc_spab * sc_spbc + sc_spac * sc_spbb ) / sc_den;

        % compute second radius %
        sc_rb = ( + sc_spab * sc_spac - sc_spbc * sc_spaa ) / sc_den;

    end
