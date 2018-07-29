function [pso F] = pso_2D()
%   FUNCTION PSO  --------USE Particle Swarm Optimization Algorithm
%global present;
% close all;
pop_size = 30;          %   pop_size ��Ⱥ��С
part_size = 2;          %   part_size ���Ӵ�С,                                                                      ** =n-D
gbest = zeros(1,part_size+1);            %   gbest ��ǰ����������С��ֵ
max_gen = 60;          %   max_gen ����������
region=zeros(part_size,2);  %   �趨�����ռ䷶Χ
region=[0,1;0,1];          %                                                                                      **ÿһά�趨��ͬ��Χ
rand('state',sum(100*clock));   %   ���������������״̬
arr_present = ini_pos(pop_size,part_size);   %   present ��ǰλ��,�����ʼ��,rand()�ķ�ΧΪ0~1

v=ini_v(pop_size,part_size);             %   ��ʼ����ǰ�ٶ�


pbest = zeros(pop_size,part_size+1);      %   pbest ������ǰ������������ֵ�����һ�а�����Щֵ����Ӧ��
w_max = 0.9;                            %   w_max Ȩϵ�����ֵ
w_min = 0.4;
v_max = 0.2;             %                                                                                          **����ٶ�,Ϊ���ӵķ�Χ���
c1 = 2;                   %   ѧϰ����
c2 = 2;                   %   ѧϰ����
best_record = zeros(1,max_gen);     %   best_record��¼��õ����ӵ���Ӧ�ȡ�
%  ������������������������������������������������
%   ����ԭʼ��Ⱥ����Ӧ��,����ʼ��
%  ������������������������������������������������
arr_present(:,end)=ini_fit(arr_present,pop_size,part_size);

% for k=1:pop_size
%     present(k,end) = fitness(present(k,1:part_size));  %����ԭʼ��Ⱥ����Ӧ��
% end

pbest = arr_present;                                        %��ʼ��������������ֵ
[best_value best_index] = min(arr_present(:,end));         %��ʼ��ȫ�����ţ�����Ӧ��Ϊȫ����С��ֵ��������ҪҲ����ѡȡΪ���ֵ
gbest = arr_present(best_index,:);
%v = zeros(pop_size,1);          %   v �ٶ�
%  ������������������������������������������������
%   ����
%  ������������������������������������������������
% global m;
% m = moviein(100o);      %����֡����
x=[0:0.01:1];
y=[0:0.01:1];
z=@(x,y) (10+20.*x.*(exp(-2*x)-exp(-2*y))./(x-y)-8.5).^2 ...
     +(10+20*x.*(exp(-7*x)-exp(-7*y))./(x-y)-7).^2 ...
     +(10+20*x.*(exp(-9*x)-exp(-9*y))./(x-y)-6.1).^2 ...
     +(10+20*x.*(exp(-14*x)-exp(-14*y))./(x-y)-7.2).^2;
for i=1:max_gen
    grid on;
    %     plot3(x,y,z);
    %     subplot(121),ezmesh(z),hold on,grid on,plot3(arr_present(:,1),arr_present(:,2),arr_present(:,3),'*'),hold off;
    %     subplot(122),ezmesh(z),view([145,90]),hold on,grid on,plot3(arr_present(:,1),arr_present(:,2),arr_present(:,3),'*'),hold off;
    ezmesh(z) ,hold on,grid on,plot3(arr_present(:,1),arr_present(:,2),arr_present(:,3),'*'),hold off;
    axis([-1 1 -1 1 -10 10])
    drawnow
    F(i)=getframe;

    %     ezmesh(z)
    % %     view([-37,90])
    %     hold on;
    %     grid on;
    %     %   plot(-0.0898,0.7126,'ro');
    %     plot3(arr_present(:,1),arr_present(:,2),arr_present(:,3),'*');                                                  %��Ϊ��ά
    %     hold off;
    pause(0.01);
    %     m(:,i) = getframe;        %���ͼ��
    w = w_max-(w_max-w_min)*i/max_gen;
    %    fprintf('#  %i ����ʼ��\n',i);
    %   ȷ���Ƿ�Դ�ɢ�Ѿ�����������Ⱥ������������������������������������������������������������
    reset = 0;          %   reset = 1ʱ����Ϊ����Ⱥ��������ʱ�����ɢ�������1�򲻴�ɢ
    if reset==1
        bit = 1;
        for k=1:part_size
            bit = bit&(range(arr_present(:,k))<0.1);
        end
        if bit==1       %   bit=1ʱ������λ�ü��ٶȽ����������
            arr_present = ini_pos(pop_size,part_size);   %   present ��ǰλ��,�����ʼ��
            v = ini_v(pop_size,part_size);           %   �ٶȳ�ʼ��
            for k=1:pop_size                                    %   ���¼�����Ӧ��
                arr_present(k,end) = fitness(arr_present(k,1:part_size));
            end
            warning('���ӹ��ּ��У����³�ʼ������');      %   ������Ϣ
            display(i);
        end
    end

    for j=1:pop_size
        v(j,:) = w.*v(j,:)+c1.*rand.*(pbest(j,1:part_size)-arr_present(j,1:part_size))...
            +c2.*rand.*(gbest(1:part_size)-arr_present(j,1:part_size));                        %  �����ٶȸ��� (a)

        %   �ж�v�Ĵ�С������v�ľ���ֵС��5��������������������������������������������������������
        c = find(abs(v)>0.2);                                                                                              %**����ٶ����ã����ӵķ�Χ���
        v(c) = sign(v(c))*0.2;   %����ٶȴ���3.14���ٶ�Ϊ3.14

        arr_present(j,1:part_size) = arr_present(j,1:part_size)+v(j,1:part_size);              %  ����λ�ø��� (b)
        arr_present(j,end) = fitness(arr_present(j,1:part_size));

        if (arr_present(j,end)<pbest(j,end))&(Region_in(arr_present(j,:),region))     %   ������������pbest,�������С��ֵΪС�ں�,�෴��Ϊ���ں�
            pbest(j,:) = arr_present(j,:);
        end

    end

    [best best_index] = min(arr_present(:,end));                                      %   �������С��ֵΪmin,�෴��Ϊmax

    if best<gbest(end)&(Region_in(arr_present(best_index,:),region))                  %   �����ǰ��õĽ������ǰ�ĺã����������ֵgbest,�������С��ֵΪС�ں�,�෴��Ϊ���ں�
        gbest = arr_present(best_index,:);
    end

    best_record(i) = gbest(end);
    display(i);
end

pso = gbest;

display(gbest);

% figure;
% plot(best_record);
% movie2avi(F,'pso_2D1.avi','compression','MSVC');


%   ***************************************************************************
%      ������Ӧ��
%   ***************************************************************************
function fit = fitness(present)
fit=(10+20*present(1)./(present(1)-present(2)).*(exp(-2*present(1))-exp(-2*present(2)))-8.5).^2 ... 
+(10+20*present(1)./(present(1)-present(2)).*(exp(-7*present(1))-exp(-7*present(2)))-7).^2 ...
+(10+20*present(1)./(present(1)-present(2)).*(exp(-9*present(1))-exp(-9*present(2)))-6.1).^2 ...
+(10+20*present(1)./(present(1)-present(2)).*(exp(-14*present(1))-exp(-14*present(2)))-7.2).^2;


function ini_present=ini_pos(pop_size,part_size)
ini_present = rand(pop_size,part_size+1);        %��ʼ����ǰ����λ��,ʹ������ķֲ��ڹ����ռ�                         %** 6��Ϊ�Ա�����Χ


function ini_velocity=ini_v(pop_size,part_size)
ini_velocity =0.2*(rand(pop_size,part_size));        %��ʼ����ǰ�����ٶ�,ʹ������ķֲ����ٶȷ�Χ��


function flag=Region_in(pos_present,region)
[m n]=size(pos_present);
flag=1;
for j=1:n-1
    flag=flag&(pos_present(1:j)>=region(j,1))&(pos_present(1:j)<=region(j,2));
end


function arr_fitness=ini_fit(pos_present,pop_size,part_size)
for k=1:pop_size
    arr_fitness(k,1) = fitness(pos_present(k,1:part_size));  %����ԭʼ��Ⱥ����Ӧ��
end
