
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

    % @brief Rotation application
    %
    % This function simply applies the provided rotation matrix on the set of
    % points also provided as parameter.
    %
    % @param sc_point Points set
    % @param sc_r     Rotation matrix
    %
    % @return sc_rotate Rotated points set

    function sc_rotate = algorithm_rotate( sc_point, sc_r )

        % initialise memory %
        sc_rotate = zeros( size( sc_point ) );

        % parsing points %
        for sc_i = 1 : size( sc_point, 1 )

            % apply rotation %
            sc_rotate(sc_i,:) = ( sc_r * sc_point(sc_i,:)' )';

        end

    end
