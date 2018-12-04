
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

    function [ sc_ra_, sc_rb_, sc_da_, sc_db_ ] = algorithm_filter( sc_ra, sc_da, sc_rb, sc_db, sc_tolerence )

        % compute mean values %
        sc_ma = mean( sc_ra );
        sc_mb = mean( sc_rb );

        % compute standard deviation %
        sc_sa = std( sc_ra ) * sc_tolerence;
        sc_sb = std( sc_rb ) * sc_tolerence;

        % initialise filtering index %
        sc_j = 0;

        % parsing features %
        for sc_i = 1 : length( sc_ra )

            % check filtering condition %
            if ( abs( sc_ra(sc_i) - sc_ma ) < sc_sa )

                % check filtering condition %
                if ( abs( sc_rb(sc_i) - sc_mb ) < sc_sb )

                    % update index %
                    sc_j = sc_j + 1;

                    % select feature %
                    sc_ra_(sc_j,1) = sc_ra(sc_i);
                    sc_rb_(sc_j,1) = sc_rb(sc_i);

                    % select feature %
                    sc_da_(sc_j,:) = sc_da(sc_i,:);
                    sc_db_(sc_j,:) = sc_db(sc_i,:);

                end

            end

        end

    end
