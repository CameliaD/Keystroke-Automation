<#
.SYNOPSIS
        Keystroke Automation prevents your computer from going idle during periods of inactivity by automating keystrokes.

.DESCRIPTION
        Keystroke Automation is a PowerShell script that runs by automatically pressing a key every 30 seconds to keep your computer awake. It is designed to prevent your computer from going idle during periods of inactivity, allowing you to use applications that go idle after a period of inactivity or avoid interruptions to time-consuming tasks due to sleep mode. 

.NOTES
    Author: Camelia Bobaru
    Date: 19.02.2023
#>

Add-Type -AssemblyName PresentationFramework
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$scriptLocationOnThisPC = split-path -parent $MyInvocation.MyCommand.Definition
$configFilesLocationOnThisPC = "$scriptLocationOnThisPC\Config"
[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="Keystroke" Height="450" Width="634" ResizeMode="CanMinimize">
    <Window.Icon>
        <DrawingImage />
    </Window.Icon>
    <Window.Foreground>
        <ImageBrush/>
    </Window.Foreground>
    <Window.Background>
        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background.jpg"/>
    </Window.Background>
    <Grid VerticalAlignment="Top">
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Button Name="btnStart" Content="Start" HorizontalAlignment="Left" Height="75" Margin="100,270,0,0" VerticalAlignment="Top" Width="165" FontSize="28" FontWeight="Bold" FontFamily="Segoe UI Black" Focusable="False" BorderThickness="0" SnapsToDevicePixels="True" Cursor="Hand">
           <Button.Style>
                    <Style TargetType="{x:Type Button}">
                        <Setter Property="Background" >
                            <Setter.Value>
                                <ImageBrush ImageSource="$configFilesLocationOnThisPC\buttonA.jpg"></ImageBrush>
                            </Setter.Value>
                        </Setter>
                        <Setter Property="Template">
                            <Setter.Value>
                                <ControlTemplate TargetType="{x:Type Button}">
                                    <Border Background="{TemplateBinding Background}">
                                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Border>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                        <Style.Triggers>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Background" >
                                    <Setter.Value>
                                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\buttonII.jpg"></ImageBrush>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
              </Button.Style>
        </Button>
        <Button Name="btnStop" Content="Stop" HorizontalAlignment="Right" Height="75" Margin="0,270,100,0" VerticalAlignment="Top" Width="165" FontSize="28" FontWeight="Bold" FontFamily="Segoe UI Black" Cursor="Hand" BorderThickness="0" SnapsToDevicePixels="True" Focusable="False">
                <Button.Style>
                    <Style TargetType="{x:Type Button}">
                        <Setter Property="Background" >
                            <Setter.Value>
                                <ImageBrush ImageSource="$configFilesLocationOnThisPC\buttonA.jpg"></ImageBrush>
                            </Setter.Value>
                        </Setter>
                        <Setter Property="Template">
                            <Setter.Value>
                                <ControlTemplate TargetType="{x:Type Button}">
                                    <Border Background="{TemplateBinding Background}">
                                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    </Border>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                        <Style.Triggers>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Background" >
                                    <Setter.Value>
                                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\buttonII.jpg"></ImageBrush>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
              </Button.Style>
        </Button>

        <TextBox Name="tbKey" Height="133" TextWrapping="Wrap" Text="Prt Sc" Width="133" HorizontalContentAlignment="Center" Margin="100,75,100,0" HorizontalAlignment="Center" Padding="15,0" VerticalAlignment="Top" BorderBrush="{x:Null}" FontSize="15" VerticalContentAlignment="Center" IsReadOnly="True" Cursor="Arrow" Focusable="False" BorderThickness="0" FontFamily="Segoe UI Black" Foreground="#FF102D4F">
            <TextBox.BindingGroup>
                <BindingGroup/>
            </TextBox.BindingGroup>
            <TextBox.Background>
                <ImageBrush ImageSource="$configFilesLocationOnThisPC\Key.jpg" Stretch="Uniform"/>
            </TextBox.Background>
        </TextBox>
        <Button Name="btnLeft" Content="&#x25C0;" HorizontalAlignment="Left" Height="35" Margin="170,123,0,0" VerticalAlignment="Top" Width="35" RenderTransformOrigin="5.286,-3.571" Background="{x:Null}" BorderBrush="White" Cursor="Hand" BorderThickness="0" Opacity="0.995" FontSize="18" Foreground="#FF102D4F"/>
        <Button Name="btnRight" Content=Content="&#x25B6;" HorizontalAlignment="Right" Height="35" Margin="0,123,170,0" VerticalAlignment="Top" Width="35" RenderTransformOrigin="-2.714,-4.429" Background="{x:Null}" BorderBrush="White" Cursor="Hand" BorderThickness="0" FontSize="18" Foreground="#FF102D4F"/>
        <Label Name="LBWatch" Content="Choose the key and press START!" HorizontalAlignment="Center" Height="50" Margin="100,205,100,0" VerticalAlignment="Top" Width="500"  HorizontalContentAlignment="Center" VerticalContentAlignment="Center" FontFamily="Segoe UI Black" FontSize="14"/>
    </Grid>
</Window>


"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader"; exit}
 
# Store Form Objects In PowerShell

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

# Create list of keys

$btnStop.IsEnabled = $false
$keys = @('PRTSC','F5','.','NUMLOCK','SCROLLLOCK')
$currentKeyIndex = 0
$tbKey.Text = $keys[$currentKeyIndex]

 
# Create timer for key press

$global:timer = New-Object System.Windows.Forms.Timer
$global:timer.Interval = 30000

$global:TBlink = New-Object System.Windows.Forms.Timer
$global:TBlink.Interval = 1000
$global:TBlink.add_tick({ 
    --$global:CountDown
    If ($global:CountDown -lt 0) {
        $uri = new-object system.uri("$configFilesLocationOnThisPC\Key.jpg")
        $imagesource = new-object System.Windows.Media.Imaging.BitmapImage $uri 
        $imagebrush = new-object System.Windows.Media.ImageBrush  $imagesource
        $TBkey.Background = $imagebrush
        $LBWatch.Content = "Running keystrokes every 30 sec."
    } 
})

$global:timer.add_tick({ 
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $Key = '{'+$TBkey.Text+'}'
    [System.Windows.Forms.SendKeys]::SendWait($Key)
    $LBWatch.Content = "&#x1F4A5;"

    $uri = new-object system.uri("$configFilesLocationOnThisPC\Key Press.jpg")
    $imagesource = new-object System.Windows.Media.Imaging.BitmapImage $uri 
    $imagebrush = new-object System.Windows.Media.ImageBrush  $imagesource
    $TBkey.Background = $imagebrush

    $global:CountDown = 1
    $global:TBlink.Start()
})
#$global:timer.Enabled =$false

# Add click actions for arrows
$btnRight.Add_click({
    if($script:currentKeyIndex -eq (($keys.Count) - 1)) {
        $script:currentKeyIndex = 0
    }
    else {
        $script:currentKeyIndex++
    }
    $tbKey.Text = $keys[$script:currentKeyIndex]
})

$btnLeft.Add_click({
    if($script:currentKeyIndex -eq 0) {
        $script:currentKeyIndex = ($keys.Count) - 1
    }
    else {
        $script:currentKeyIndex--
    }
    $tbKey.Text = $keys[$script:currentKeyIndex]
})



# Add click actions for Start and Stop buttons

$btnStart.Add_Click({
    $btnStop.IsEnabled = $true
    $btnRight.IsEnabled = $false
    $btnLeft.IsEnabled = $false
    $btnStart.IsEnabled = $false
    $LBWatch.Content = "Running keystrokes every 30 sec."
    #$global:timer.Enabled =$true
    $global:timer.start()
})

$btnStop.Add_Click({
    $btnStop.IsEnabled = $false
    $btnRight.IsEnabled = $true
    $btnLeft.IsEnabled = $true
    $btnStart.IsEnabled = $true

    $global:timer.stop()
    $global:TBlink.Stop()
    $LBWatch.Content = "Choose the key and press START!"
})


$Form.ShowDialog()

