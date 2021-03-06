
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

    % @brief Point sets registration
    %
    % This function estimates the best rotation and translation that matches
    % the two provided sets of 3D points, assuming their structural identity.
    %
    % The returned rotation matrix and translation vector verify :
    %
    %     sc_q = sc_r * sc_p + sc_t
    %
    % The function performs a correction of the rotation matrix in case it is
    % estimated with a negative determinant (-1).
    %
    % @param sc_p First points set - n by 3 array
    % @param sc_q Second points set - n by 3 array
    %
    % @return sc_r Estimated rotation matrix
    % @return sc_t Estimated translation vector

    function [ sc_r sc_t ] = algorithm_register( sc_p, sc_q )

        % memory management %
        sc_m = zeros( 3, 3 );

        % compute sets centroid %
        sc_c = sum( sc_p ) / size( sc_p, 1 );
        sc_d = sum( sc_q ) / size( sc_q, 1 );

        % correlation natrix %
        for i = 1 : size( sc_p, 1 );

            % correlation accumulation - diadic product %
            sc_m = sc_m + ( sc_p(i,1:3) - sc_c(1:3) )' * ( sc_q(i,1:3) - sc_d(1:3) );

        end

        % singular value decomposition %
        [ sc_u sc_s sc_v ] = svd( sc_m );

        % compute rotation matrix %
        sc_r = sc_v * sc_u';

        % compute translation vector %
        sc_t = sc_d' - sc_r * sc_c';

        % check for inversion in rotation matrix %
        if ( det( sc_r ) < 0 );

            % inversion correction %
            sc_v(:,3) = -sc_v(:,3); sc_r = sc_v * sc_u';

            % compute translation vector %
            sc_t = sc_d' - sc_r * sc_c';

            % display warning %
            warning( 'inversion detected' );

        end

    end

