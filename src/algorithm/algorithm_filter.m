
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

    % @brief Camera features filtering
    %
    % This function considers two camera sets of features, through their radius
    % values and performs a statistical analysis on them. the goal is to detect
    % if one or more features can be considered as outliers, leading to pose
    % estimation instabilities. Such features are eliminated by the function.
    %
    % The function performs a statistical analysis on the radii of both cameras
    % and removes features that are 'sc_tolerance' times the standard deviation
    % away from the mean value. To be kept, a features has to be in the range
    % for both cameras.
    %
    % The features direction arrays have to be provided in order to remove the
    % vectors that correspond to a removed feature.
    %
    % @param sc_ra        First camera radii
    % @param sc_da        First camera features direction unitary vectors
    % @param sc_rb        Second camera radii
    % @param sc_db        Second camera features direction unitary vectors
    % @param sc_tolerance Standard deviation filtering factor
    %
    % @return sc_ra_      First camera filtered radii
    % @return sc_rb_      Second camera filtered radii
    % @return sc_da_      First camera filtered features direction unitary vectors
    % @return sc_db_      Second camera filtered features direction unitary vectors

    function [ sc_ra_, sc_rb_, sc_da_, sc_db_ ] = algorithm_filter( sc_ra, sc_da, sc_rb, sc_db, sc_tolerance )

        % compute mean values %
        sc_ma = mean( sc_ra );
        sc_mb = mean( sc_rb );

        % compute standard deviation %
        sc_sa = std( sc_ra ) * sc_tolerance;
        sc_sb = std( sc_rb ) * sc_tolerance;

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
