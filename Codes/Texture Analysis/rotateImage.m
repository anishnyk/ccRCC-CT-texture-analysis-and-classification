function J = rotateImage( I, theta )
    
    [M,N] = size(I);
    J = zeros(M,N);

    for m = 1:M
        for n = 1:N
            % Perform geometrical transformation
            nDash = round(n*cos(theta) - m*sin(theta));
            mDash = round(n*sin(theta) + m*cos(theta));
                
            % Convert back to MATLAB coordinates
            while (mDash<1 || mDash>M)
                if mDash < 1
                    mDash = mDash + M;
                elseif mDash > M
                    mDash = mDash - M;
                end
            end
            while (nDash<1 || nDash>N)
                if nDash < 1
                    nDash = nDash + N;
                elseif nDash > N
                    nDash = nDash - N;
                end
            end

            J(m, n) = I(mDash, nDash);
        end
    end
       
end

