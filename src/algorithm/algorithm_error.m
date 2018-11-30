
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

    function sc_error = algorithm_error( sc_ca, sc_da, sc_ra, sc_cb, sc_db, sc_rb )

        % compute point set %
        sc_pa = sc_ca + algorithm_features( sc_ra, sc_da );

        % compute point set %
        sc_pb = sc_cb + algorithm_features( sc_rb, sc_db );

        % error extremum %
        sc_error = 0.0;

        % parsing features %
        for sc_i = 1 : size( sc_da, 1 )

            % compute feature error %
            sc_local = norm( sc_pa(sc_i,:) - sc_pb(sc_i,:) );

            % detect extremum %
            if ( sc_local > sc_error )

                % update extremum %
                sc_error = sc_local;

            end

        end

    end
