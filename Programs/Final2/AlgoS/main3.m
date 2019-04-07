function [algo_3,y]=main3(k,R,M)%greedy algorithm
G=reedmullergen(R,M);
sum1=0;
for idx=0:M
    sum1=sum1+nchoosek(M,idx);
    if(sum1>=k)
        break;
    end
end
if(sum1==k)
    algo_3=G;
    y=[1:k];
    else
    sum1=sum1-nchoosek(M,idx);
    y=[1:sum1+1];
    rows_left=-sum1+k;%%These are the extra number of rows left;
    algo_3=G(1:sum1, :);

    Gextra=G(sum1+1, :);
    T=G((sum1+1)+1:sum1+nchoosek(M,idx), :);
    index_T=[sum1+2:sum1+nchoosek(M,idx)];
    rows_left=rows_left-1;
    rows_T=nchoosek(M,idx)-1;
    R=zeros(1,rows_T);

    rows_Gextra=1;

    while(rows_left>0)
        for idy=1:rows_T
            for idz=1:rows_Gextra
                R(idy)= R(idy)+sum(T(idy, :).*Gextra(idz, :));
            end
        end    
    %     [~,index]=min(R);
        minR=min(R);
        R_logical=(R==minR);
        R_indices=find(R_logical);
        [z,~]=datasample(R_indices,1);
        index=z;
        Gextra=[Gextra;T(index, :)];%%conider for later Gextra(rows_Gextra+1) and preallocate this thing if it slows down this program
        T(index, :)=[];
        y(sum1+rows_Gextra+1)=index_T(index);
        index_T(index)=[];

        rows_left=rows_left-1;
        rows_T=rows_T-1;
        rows_Gextra=rows_Gextra+1;
        R=zeros(1,rows_T);

    end
    algo_3=[algo_3;Gextra];
end

end