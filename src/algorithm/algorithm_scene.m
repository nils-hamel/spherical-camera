
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

    % @brief Random spherical scene
    %
    % This function allows to generate and random set of point homogeneously
    % distributed in a sphere or on a sphere using the provided center and
    % radius.
    %
    % If the provided 'hollow' parameter is set to false, the random points are
    % distributed in the sphere volume. If 'true' is provided, the points are
    % distributed on the surface of the sphere.
    %
    % @param sc_center Scene sphere center
    % @param sc_radius Scene sphere radius
    % @param sc_number Number of point to generate
    % @param sc_hollow Scene sphere hollow condition
    %
    % @return sc_scene Computed random scene.

    function sc_scene = algorithm_scene( sc_center, sc_radius, sc_number, sc_hollow )

        % memory management %
        sc_param = zeros( sc_number, 4 );

        % scene precursor %
        sc_param(:,1) = rand( sc_number, 1 );

        % scene precursor %
        sc_param(:,2) = randn( sc_number, 1 );
        sc_param(:,3) = randn( sc_number, 1 );
        sc_param(:,4) = randn( sc_number, 1 );

        % compute radial factor %
        sc_norm = sc_radius ./ sqrt( sc_param(:,2) .* sc_param(:,2) + sc_param(:,3) .* sc_param(:,3) + sc_param(:,4) .* sc_param(:,4) );

        % check hollow condition %
        if ( sc_hollow == false )

            % apply correction %
            sc_norm = ( sc_param(:,1) .^ ( 1./3. ) ) .* sc_norm;

        end

        % memory management %
        sc_scene = zeros( sc_number, 3 );

        % compute scene points %
        sc_scene(:,1) = sc_norm .* sc_param(:,2);
        sc_scene(:,2) = sc_norm .* sc_param(:,3);
        sc_scene(:,3) = sc_norm .* sc_param(:,4);

    end
