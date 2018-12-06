
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

    % @brief Features position computation
    %
    % This function allows to compute the position of the features of a camera
    % in its own frame.
    %
    % The function simply applies the provided radius values their respective
    % unitary direction vectors.
    %
    % @param sc_r Camera features radii
    % @param sc_d Camera features directions unitary vector
    %
    % @return sc_point Computed features position in the camera frame

    function sc_point = algorithm_features( sc_r, sc_d )

        % compute point position %
        sc_point(:,1) = sc_r(:) .* sc_d(:,1);
        sc_point(:,2) = sc_r(:) .* sc_d(:,2);
        sc_point(:,3) = sc_r(:) .* sc_d(:,3);

    end
