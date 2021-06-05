
function outshine_test(x)

% * step 1
x=x+3;
% * loop
for i=1:length(x)
    % ** what s going on
    % *** which
    y(i)=x(i)^2;
    % *** who
    for k=1:length(x)
        y(i)=x(k)-1;
    end
    % ** that 
    z(i)=y(i)-1;
end
% * step 2
% ** plot y over x
plot(x,y)
% ** plot z over x
figure
plot(x,z)
% * step 3
disp('hello')

end