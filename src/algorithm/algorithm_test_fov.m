
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

    function algorithm_test_fov( sc_count, sc_amount, sc_output )

        % create scene %
        sc_scene = algorithm_scene( zeros(1,3), 10, sc_count, false );

        % create camera position %
        sc_position = linspace( 2, 20, 10 );


        for sc_i = 1 : length( sc_position )

            % create scene %
            sc_scene = algorithm_scene( zeros(1,3), 10, sc_count, false );

            % create camera center %
            sc_camac = [ +sc_position( sc_i ), rand-0.5, rand-0.5 ];
            sc_cambc = [ -sc_position( sc_i ), rand-0.5, rand-0.5 ];

            % compute directions - features %
            sc_camad = algorithm_project( sc_camac, eye(3), sc_scene );
            sc_cambd = algorithm_project( sc_cambc, eye(3), sc_scene );

            % compute camera pose %
            [ sc_r, sc_t, sc_ra, sc_rb, sc_da, sc_db, sc_err_rad ] = algorithm_pose( sc_camad, sc_cambd, 1e-8 );

            sc_iter(sc_i) =  length( sc_err_rad );

        end

        plot( sc_position, sc_iter );

    end
