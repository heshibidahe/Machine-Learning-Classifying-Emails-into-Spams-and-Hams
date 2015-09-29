%% preparation
clear;
load train_matrix.txt;
load test_matrix.txt;
%test filter: some columns are all zero.
[row, col]=find(test_matrix>0);
original_emails=size(test_matrix,2);
I(size(test_matrix,2))=false;
for i=1:length(col)
    I(col(i))=true;
end
I=logical(I);
test_matrix=test_matrix(:,I);

%% initialization
I=randperm(size(train_matrix,2));
train_matrix=train_matrix(:,I);
X=sparse(train_matrix(1:end-1,:));
y=train_matrix(end,:);
m=size(train_matrix,1)-1;
n=size(train_matrix,2);
theta = rand(m,1)*0.1;  %this shows the initialization's influence

%% gradient check
disp(grad_check(@logistic_regression_vec,theta,10,X,y));
%% start training
iterations=1200;
eta=0.3;
fprintf('features=%d;\tsamples=%d;\tlearning rate is %f\n',m,n,eta);
for i=1:iterations
    [f,g]=logistic_regression_vec(theta,X,y);
    theta=theta-1/n*eta*g;
    if mod(i,100)==0
        fprintf('iter= %d  cost= %f\n',i,f);
    end
end
answer=h_theta(theta,X);
for i=1:length(answer)
    if answer(i)>=0.5
        answer(i)=1;
    else
        answer(i)=0;
    end
end
answer=answer-y;
wrong=length(find(answer~=0));
fprintf('training accuracy is %d/%d   %4.2f\n',wrong,n,((n-wrong)/n)*100);

%% start testing
X=sparse(test_matrix(1:end-1,:));
y=test_matrix(end,:);
answer=h_theta(theta,X);
for i=1:length(answer)
    if answer(i)>=0.5
        answer(i)=1;
    else
        answer(i)=0;
    end
end
answer=answer-y;
wrong=length(find(answer~=0));
total=size(test_matrix,2);
fprintf('lost emails=%d\ntesting accuracy is %d/%d   %4.2f\n', ...
original_emails-total,wrong,total,((total-wrong)/total)*100);