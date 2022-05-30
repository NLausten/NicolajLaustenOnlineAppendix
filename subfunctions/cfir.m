% function: cfir.m
% Implementation of Bernanke, Gertler and Watson (1997)'s counterfactuals exactly as written in Kilian and Lewis
% (2011), sections 3.1 and 3.2
%
% This is a modified version of the code written by Lewis in September 2009. 
% It requires variables Uf and EBP positions (1 and 2, respectively).
% 
%-------------------------------------------------------------------------------
% Input:    bhat, matrix of estimated reduced form coefficients
%           Phat, structural error term matrix (often chol(sigmauhat)')
%           K, number of variables in the system
%           horiz, number of periods to estimate
%           p, number of lags
% Output:   bgwirf, a matrix of BGW counterfactual impulse responses
%           bgwcfshocks, a vector of shocks to FU to implement BGW counterfactuals
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
function [bgwirf, bgwcfshocks] = cfir(bhat,Phat,K,horiz,p)
%-------------------------------------------------------------------------------


%%% Construct the B matrix (section 3.1, Kilian and Lewis (2011)) %%%

% Drop the intercept term from bhat
bhat = bhat(2:end,:);
bhat = bhat';

% First, assemble structural A matrices A1 ... Ap for inclusion into B
B = zeros(K,K*(p + 1));

% Next, determine the matrix of contemporaneous coefficients
for i = 1:K
    A0 = inv(Phat);
    ey = zeros(1,K);
    ey(i) = 1;
    B(i,1:K) = -A0(i,:)/A0(i,i) + ey;
end

A0 = eye(K,K) - B(:,1:K);
for i = 1:p
    B(:,i*K+1:(i+1)*K) = A0*bhat(:,(i-1)*K+1:i*K);
end


%-------------------------------------------------------------------------------
%%% Counterfactual simulations (section 3.2, Kilian and Lewis (2011)) %%%

x = zeros(K,horiz+1);
z = zeros(K,horiz+1);
bgwcfshocks = zeros(1,horiz+1);


% Time 0 %

% 1: FU shock position
x(:,1) = Phat(:,1);
bgwcfshocks(1,1) = -B(2,1:K)*x(:,1); % 2 = variable EBP position
z(:,1) = x(:,1) + Phat(:,2)*bgwcfshocks(1,1)/Phat(2,2); 

% This is written exactly as in the paper, but could be vectorized
for h = 1:horiz
    % Simulate the system
    for i = 1:K
        for m = 1:min(p,h)
            for j = 1:K
                x(i,h+1) = x(i,h+1) + B(i,m*K+j)*z(j,h-m+1);
                % x(i,h+1) = x(i,h+1) + B(i,m*K+j)*z(i,h-m+1);
            end
        end
        if (i > 1)
            for j = 1:(i-1)
                x(i,h+1) = x(i,h+1) + B(i,j)*x(j,h+1);
            end
        end
    end
    
    
    %%--Counterfactual Shocks--%%
    
      % (1) Lagged responses:
    for m = 1:min(p,h)
        for j = 1:K
            bgwcfshocks(1,h+1) = bgwcfshocks(1,h+1) - B(2,m*K+j)*z(j,h-m+1);
        end
    end
    
      % (2) Contemporaneous responses:  
    for j = 1:K
        bgwcfshocks(1,h+1) = bgwcfshocks(1,h+1) - B(2,j)*x(j,h+1);
    end
    
    
    % Finally, re-calculate z
    z(:,h+1) = x(:,h+1) + Phat(:,2)*bgwcfshocks(1,h+1)/Phat(2,2);
end
bgwirf = z;



