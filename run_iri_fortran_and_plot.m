% function run_iri_fortran_and_plot()
% 参数设置
lat = 10.0;      % 纬度，浮点数
lon = 30.0;     % 经度，浮点数
year = 2025;     % 年,整数
month = 3;       % 月,整数
day = 1;         % 日,整数
hour = 0;        % 时,整数
minute = 0;      % 分,整数
second = 0;      % 秒,整数
iut = 0;         % 1=UT时间,=0 LT时间,整数
ndays = 1;       % 从当前日期往后算的总天数,正整数
dt_min = 15;     % 时间间隔(分钟),正整数

% 构建可执行文件命令
exe_path = 'IRI_site_switch.exe'; % 替换为实际可执行文件路径
cmd = sprintf('%s %f %f %d %d %d %d %d %d %d %d %d', ...
    exe_path, lat, lon, year, month, day, hour, minute, second, iut, ndays, dt_min);

% 运行Fortran程序
disp(['Running Fortran executable: ' cmd]);
[status, result] = system(cmd);
if status ~= 0
    error('Failed to run Fortran executable: %s', result);
end

% 输出文件名
datestr = sprintf('%04d%02d%02dT%02d%02d', year, month, day, hour, minute);
output_file = ['Ion_Site_' datestr '.txt'];

% 读取输出数据
if ~exist(output_file, 'file')
    error('Output file not found: %s', output_file);
end

% 读取数据(跳过注释行)
fid = fopen(output_file, 'r');
data = textscan(fid, '%d %d %d %d %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', ...
    'CommentStyle', '%', 'HeaderLines', 4);
fclose(fid);

% 提取数据
% [yy, mm, dd, HH, MM, SS, F107, Ap, Kp, lati, longi, mLat, mLon, ...
%  foF2, foF1, foE, M3000, MUF3000, hmF2, hmF1, hmE, B0, B1, TEC, sF_Prob, Es_Prob] = deal(data{:});
% 提取数据并转换为双精度
yy = double(data{1});
mm = double(data{2});
dd = double(data{3});
HH = double(data{4});
MM = double(data{5});
SS = double(data{6});
F107 = data{7};
Ap = data{8};
Kp = data{9};
lati = data{10};
longi = data{11};
mLat = data{12};
mLon = data{13};
foF2 = data{14};
foF1 = data{15};
foE = data{16};
M3000 = data{17};
MUF3000 = data{18};
hmF2 = data{19};
hmF1 = data{20};
hmE = data{21};
B0 = data{22};
B1 = data{23};
TEC = data{24};
sF_Prob = data{25};
Es_Prob = data{26};

% 创建时间轴
% time_datenum = datenum(yy, mm, dd, HH, MM, SS);% 老版本的matlab
time_datenum = datetime([yy, mm, dd, HH, MM, SS]);

% 绘制图形
% 子图1: 太阳地磁指数
figure('Position', [10, 10, 1200, 800]);
subplot(4,1,1);
yyaxis left;
plot(time_datenum, F107, 'r-', 'LineWidth', 2); hold on;
ylabel('F10.7 index')
yyaxis right;
stairs(time_datenum, Ap, 'b--', 'LineWidth', 2);
stairs(time_datenum, Kp, 'k-.', 'LineWidth', 2);
ylabel('AP/Kp index');
datetick('x', 'HH:MM');
legend('F10.7', 'AP', 'KP','Location', 'best');
title(['Ionospheric Parameters at Lati=' num2str(lat) '°, Longi=' num2str(lon),'°']);

% 子图2: 临界频率
subplot(4,1,2);
plot(time_datenum, foF2, 'r-', 'LineWidth', 2); hold on;
plot(time_datenum, foF1, 'b-', 'LineWidth', 2);
plot(time_datenum, foE, 'k-', 'LineWidth', 2);
datetick('x', 'HH:MM');
ylabel('Frequency (MHz)');

legend('foF2', 'foF1', 'foE', 'Location', 'best');
grid on;

% 子图3: 高度/厚度参数
subplot(4,1,3);
yyaxis left;
plot(time_datenum, hmF2, 'r-', 'LineWidth', 2); hold on;
plot(time_datenum, hmF1, 'b-', 'LineWidth', 2);
plot(time_datenum, hmE, 'k-', 'LineWidth', 2);
ylabel('Peak Height (km)');

yyaxis right;
plot(time_datenum, B0, 'm--', 'LineWidth', 2);
plot(time_datenum, B1, '-.', 'LineWidth', 2,'Color',[0.4 0.5 0.2]);
ylabel('Thickness (km)');

datetick('x', 'HH:MM');
legend('hmF2', 'hmF1', 'hmE', 'B0','B1','Location', 'best');
grid on;

% 子图4: TEC和Es发生概率
subplot(4,1,4);
yyaxis left;
plot(time_datenum, TEC, 'k-', 'LineWidth', 2);
ylabel('TEC (TECU)');
yyaxis right;
% plot(time_datenum, sF_Prob, 'm-', 'LineWidth', 1);
plot(time_datenum, Es_Prob, 'r--', 'LineWidth', 2);
ylabel('Probability (%)');
% legend('TEC', 'Spread-F Prob', 'Es Prob', 'Location', 'best');
legend('TEC', 'Es Prob', 'Location', 'best');
datetick('x', 'HH:MM');
xlabel('Time (UT)');
grid on;


% 保存图形
saveas(gcf, ['Ionosphere_Plot_' datestr '.png']);
disp(['Plot saved as Ionosphere_Plot_' datestr '.png']);

% end