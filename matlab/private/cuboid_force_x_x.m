%% cuboid_force_z_z
%
% Calculate the forces between two parallel cuboid magnets, both magnetised in the
% z-direction.

% \START

% \begin{mfunction}{cuboid_force_x_x}

function forces_xyz = cuboid_force_x_x(size1,size2,offset,J1,J2)

J1 = J1(1);
J2 = J2(1);

if ( abs(J1)<eps || abs(J2)<eps )
  forces_xyz = [0; 0; 0];
  return
end

component_x = 0;
component_y = 0;
component_z = 0;

for ii = [1 -1]
  for jj = [1 -1]
    for kk = [1 -1]
      for ll = [1 -1]
        for pp = [1 -1]
          for qq = [1 -1]

            u = -offset(3,:) + size2(3)*jj - size1(3)*ii;
            v =  offset(2,:) + size2(2)*ll - size1(2)*kk;
            w =  offset(1,:) + size2(1)*qq - size1(1)*pp;
            r = sqrt(u.^2+v.^2+w.^2);

            atan_term = nan(size(u));
            log_ru = nan(size(u));
            log_rv = nan(size(u));
            
            ind = w==0;
            if any(ind)
              atan_term( ind) = 0;
            else
              atan_term(~ind) = atan(u(~ind).*v(~ind)./(r(~ind).*w(~ind)));
            end
            
            ind = abs(r-u) < eps;
            if any(ind)
              log_ru( ind) = 0;
            else
              log_ru(~ind) = log(r(~ind)-u(~ind));
            end
            
            ind = abs(r-v) < eps;
            if any(ind)
              log_rv( ind) = 0;
            else
              log_rv(~ind) = log(r(~ind)-v(~ind));
            end

            cx = ...
              + 0.5*(v.^2-w.^2).*log_ru ...
              + u.*v.*log_rv ...
              + v.*w.*atan_term...
              + 0.5*r.*u;

            cy = ...
              + 0.5*(u.^2-w.^2).*log_rv ...
              + u.*v.*log_ru ...
              + u.*w.*atan_term ...
              + 0.5*r.*v;

            cz = ...
              - u.*w.*log_ru ...
              - v.*w.*log_rv ...
              + u.*v.*atan_term ...
              - r.*w;

            ind_sum = ii*jj*kk*ll*pp*qq;
            component_x = component_x + ind_sum.*cx;
            component_y = component_y + ind_sum.*cy;
            component_z = component_z + ind_sum.*cz;

          end
        end
      end
    end
  end
end

forces_xyz = J1*J2/(4*pi*(4*pi*1e-7)).*[component_z; component_y; -component_x];

end

% \end{mfunction}
