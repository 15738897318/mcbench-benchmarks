function msfcn_ftdi_01(block)
% Level-2 MATLAB file S-Function for limited integrator demo.
%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ 

  setup(block);
  SetOutPortDims(block)
  
%endfunction

function setup(block)
  
  %% Register number of dialog parameters   
  block.NumDialogPrms = 4;
  %block.DialogPrm(1).DatatypeID = 7;    % 0-double, 7-uint32
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DimensionsMode      = 'Fixed'; %'Variable' 
  %block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).DirectFeedthrough = false;
  
  block.OutputPort(1).DimensionsMode      = 'Fixed'; %'Variable'
  block.OutputPort(1).DatatypeID      = 3;      % 0-double, 3-uint8,  7-uint32
  %% Set block sample time to continuous
  block.SampleTimes = [block.DialogPrm(4).Data 0];
  
  %% Setup Dwork
  block.NumContStates = 0;

  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
  %block.RegBlockMethod('InitializeConditions',    @InitConditions); % ��� ����������� ���������
  
  block.RegBlockMethod('Start', @Start);
  block.RegBlockMethod('SetOutputPortDimensions', @SetOutPortDims);
  block.RegBlockMethod('Outputs',                 @Output);  
 % block.RegBlockMethod('Derivatives',             @Derivative);   % ��� ����������� ���������
  block.RegBlockMethod('Terminate',               @Terminator); 
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup); 
  %endfunction


% function CheckPrms(block)
%   % Check the validity of the parameters.
%   p1 = block.DialogPrm(1).Data; % Amplitude
%   p2 = block.DialogPrm(2).Data; % nSample
%   p3 = block.DialogPrm(3).Data; % Period
%   p4 = block.DialogPrm(4).Data; % sampleTime
%   
%   if sum(isnan(p1)+isinf(p1))
%     error('Invalid signal magnitude parameter. Nan and inf are not allowed as parameter values.');
%   end
%   if ~sum(~isreal(p1)+isvector(p1))
%     error('Invalid signal magnitude parameter. Value should be a real scalar or vector.');
%   end
%   if sum(isnan(p2)+isinf(p2))
%     error('Invalid number of samples per frame parameter. Nan and inf are not allowed as parameter values.');
%   end
  
function SetOutPortDims(block)   %% SetOutputPortDims - Check and set output port dimensions
  
  % block.InputPort(idx).Dimensions    = di;
  %block.OutputPort(1).Dimensions = [1 block.DialogPrm(2).Data];
   block.InputPort(1).Dimensions = block.DialogPrm(2).Data;
   block.OutputPort(1).Dimensions = block.DialogPrm(3).Data;

%endfunction


function DoPostPropSetup(block)
  block.NumDworks = 2;
  
% Dwork stores the handle of the Pulse Geneator block
block.Dwork(1).Name            = 'handle'; %����� ����������
block.Dwork(1).Dimensions      = 1;
block.Dwork(1).DatatypeID      = 7;      % 0-double, 7-uint32
block.Dwork(1).Complexity      = 'Real'; % real


  block.Dwork(2).Name            = 'ConnSpeed';  % �������� ����������� 
  block.Dwork(2).Dimensions      = 1;
  block.Dwork(2).DatatypeID      = 7;      % uint32
  block.Dwork(2).Complexity      = 'Real'; % real
  block.Dwork(2).UsedAsDiscState = true;
%block.Dwork.Complexity      = 'Real'; % real
%block.Dwork.UsedAsDiscState = false;
%   block.ContStates.Name            = 'handle';
%   block.ContStates.Dimensions      = 1;
%   block.ContStates.DatatypeID      = 7;      % 0-double, 7-uint32
%   block.ContStates.Data            = 0;
  
  % Register all tunable parameters as runtime parameters.
  block.AutoRegRuntimePrms;
  
  
  
function Start(block)
%% Initialize Dwork
  % ��� FT_ListDevices
FT_LIST_NUMBER_ONLY = hex2dec('80000000');
FT_LIST_BY_INDEX = hex2dec('40000000');
FT_LIST_ALL = hex2dec('20000000');

%----------------------------------------------
% ��� FT_OpenEx

FT_OPEN_BY_SERIAL_NUMBER = 1;
FT_OPEN_BY_DESCRIPTION = 2;
FT_OPEN_BY_LOCATION = 4;

loadlibrary ftd2xx ftd2xx alias usb_lib;

%libisloaded usb_lib  % - ��������, ��������� �� ����������.
if libisloaded('usb_lib')
  disp('���������� ft232xx.lib ���������. Library ft232xx.lib loaded');
end

%libfunctionsview usb_lib; % - �������� ������� � ����������.
block.Dwork(2).Data = uint32(block.DialogPrm(1).Data);  % �������� ����������� 
a1 = uint32(0);
pa1 = libpointer('uint32Ptr', a1);

calllib('usb_lib', 'FT_ListDevices', pa1, 0, FT_LIST_NUMBER_ONLY)   % pa1 ���������� ���������� ����������� ���������

if (get(pa1,'Value')== 0)  % - ��������� ��������, �� ������� ��������� ��������� pa1
    error('���������� �� �������. No FT232RL device found.');
end
fprintf('������� ���������. Devices founded:   %u \n', get(pa1,'Value'));
%-------------------------------------------------------------
usbMem = uint32(0); 
handlePtr = libpointer('uint32Ptr',usbMem); %��������� �� �����
deviceNum = 0;  %����� ����������

open_status = calllib('usb_lib', 'FT_Open', deviceNum, handlePtr); %�������� ����������

if (open_status == 0)
    disp('���������� �������. Device is opened.');
    block.Dwork(1).Data = get(handlePtr,'Value');  %���������� �������� ������
    fprintf('����� ����������. Device handle:   %u \n', get(handlePtr,'Value'));
else
    fprintf('������ ��������, ��� ������. Error opening, error code:   %u \n', open_status);
end


%calllib('usb_lib', 'FT_SetBitMode',handle,uint8(255),uint8(1));
%disp('Baudrate');
calllib('usb_lib','FT_SetBaudRate', block.Dwork(1).Data, block.Dwork(2).Data);  %��������� �������� ����������
%disp('FT_SetDataCharacteristics');
calllib('usb_lib','FT_SetDataCharacteristics', block.Dwork(1).Data, 8, 0, 0); %handle, data_bit_8, stop_bit_1, parity_none
%disp('FT_SetFlowControl');
calllib('usb_lib','FT_SetFlowControl', block.Dwork(1).Data, 0, 0, 0);   %flow_control_none

% bites_to_wr = uint32(128);  % ���������� ���� �� ��������
% on = uint32(1:255);         % ����� ������
% onPtr = libpointer('uint32Ptr',on); % ��������� �� ����� ������
% bytes_written = uint32(128);        % ���������� ��� ���������� ������������ ����
% bytes_written_Ptr = libpointer('uint32Ptr',bytes_written); % ��������� �� ���������� ��� ���������� ������������ ����
% %-----------------------------------------------
% calllib('usb_lib','FT_Write',handle,onPtr,bites_to_wr,bytes_written_Ptr);  % ������ � ����������
% block.Dwork(1).Data = handle;
 % block.ContStates.Data = 1;   %block.DialogPrm(3).Data;
  
%endfunction

function Output(block)
 % calllib('usb_lib','FT_Read',block.Dwork(1).Data,onPtr,bites_to_wr,bytes_written_Ptr);
 %a =  uint32([1 2 3 4 5 6 7 8 9 10]);
 bites_to_wr = uint32(block.DialogPrm(2).Data);  % ���������� ���� �� ��������
 wr_buf =  uint8((block.InputPort(1).Data)');    % ����� ������ �����
 wr_bufPtr = libpointer('uint8Ptr',wr_buf); % ��������� �� ����� ������
 
 bites_to_re = uint32(block.DialogPrm(3).Data);  % ���������� ���� �� ��������
 re_buf =  uint8(zeros(1,block.DialogPrm(3).Data));  % ����� ������ �����������
 re_bufPtr = libpointer('uint8Ptr',re_buf); % ��������� �� ����� ������
 
 RxQueue = uint32(0);
  RxQueuePtr = libpointer('uint32Ptr',RxQueue);
 %TxQueue = uint32(0);
 % TxQueuePtr = libpointer('uint32Ptr',TxQueue);
 %EventStatus = uint32(0);
 % EventStatusPtr = libpointer('uint32Ptr',EventStatus);
 
 bytes_written = uint32(128);        % ���������� ��� ���������� ������������ ����
 bytes_written_Ptr = libpointer('uint32Ptr',bytes_written); % ��������� �� ���������� ��� ���������� ������������ ����
 bytes_read = uint32(128);        % ���������� ��� ���������� ������������ ����
 bytes_read_Ptr = libpointer('uint32Ptr',bytes_read); % ��������� �� ���������� ��� ���������� ������������ ����
 %-----------------------------------------------
%handle = block.Dwork(1).Data; 
 calllib('usb_lib','FT_Write',block.Dwork(1).Data, wr_bufPtr, bites_to_wr, bytes_written_Ptr);  % ������ � ����������

 %calllib('usb_lib','FT_GetStatus',block.Dwork(1).Data, RxQueue, TxQueue, EventStatus); %handle, rx,tx,event

 calllib('usb_lib','FT_GetQueueStatus',block.Dwork(1).Data, RxQueuePtr);
 
 %get(RxQueuePtr,'Value');
 if ((get(RxQueuePtr,'Value')) >= block.DialogPrm(3).Data)
     calllib('usb_lib','FT_Read',block.Dwork(1).Data, re_bufPtr, bites_to_re, bytes_read_Ptr);  % ������ � ����������
 end
 get(re_bufPtr,'Value');
 block.OutputPort(1).CurrentDimensions = block.DialogPrm(3).Data;
 block.OutputPort(1).Data = get(re_bufPtr,'Value');%1:block.DialogPrm(2).Data;       % block.Dwork(1).Data;
  
%endfunction

% function Derivative(block)
% 
%      lb = 2; %  block.DialogPrm(1).Data;
%      ub = 5;  %block.DialogPrm(2).Data;
%      u =  block.InputPort(1).Data;
% 
%      if (block.ContStates.Data <= lb && u < 0) || (block.ContStates.Data >= ub && u > 0)
%        block.Derivatives.Data = 0;
%      else
%        block.Derivatives.Data = 1;
%      end
  
%endfunction

function Terminator(block)
%handle = block.Dwork.Data;
open_status = calllib('usb_lib','FT_Close',block.Dwork(1).Data);  % �������� ����������
if (open_status == 0)
    fprintf('���������� �������. Device closed. \n');
else
    fprintf('������ ��������, ��� ������. Error closing, error code:   %u \n', open_status);
end
unloadlibrary('usb_lib')
disp(['Terminating the block with handle ' num2str(block.BlockHandle) '.']);

%endfunction
