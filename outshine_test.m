
function outshine_test(x)
% (setq outline-regexp (concat " *" comment-start comment-start "* " "\\**"))
% (setq outline-regexp (concat " *" comment-start " " "\\**"))
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
    % good
    % ** 
%T * step 2
% ** plot y over x
plot(x,y)
% ** plot z over x
figure
plot(x,z)
% * step 3
disp('hello')

end



% (setq outline-regexp " *%% [*]\\{1,8\\} ")
% Local Variables:
% outline-regexp: " *%% [*]\\{1,8\\} "
% dummy: "hello"
% End: