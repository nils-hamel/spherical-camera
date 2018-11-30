
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

    function sc_direction = algorithm_project( sc_center, sc_rotation, sc_scene )

        % memory management %
        sc_direction = zeros( size( sc_scene ) );

        % parsing scene %
        for sc_i = 1 : size( sc_scene, 1 )

            % frame transformation %
            sc_direction(sc_i,:) = sc_scene(sc_i,:) - sc_center;

            % projection on unit sphere %
            sc_direction(sc_i,:) = sc_direction(sc_i,:) / norm( sc_direction(sc_i,:) );

            % apply camera rotation %
            sc_direction(sc_i,:) = ( sc_rotation * sc_direction(sc_i,:)' )';

        end

    end
