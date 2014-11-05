#include "xiaomitool.h"
#include "ui_xiaomitool.h"

XiaomiTool::XiaomiTool(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::XiaomiTool)
{
    ui->setupUi(this);
}

XiaomiTool::~XiaomiTool()
{
    delete ui;
}

void XiaomiTool::on_RestoreB_clicked()
{
    system ("gnome-terminal -e './run.sh --backup'");
}


void XiaomiTool::on_BackupB_clicked()
{
    system ("gnome-terminal -e './run.sh --restore'");
}


void XiaomiTool::on_PushB_clicked()
{
    system ("gnome-terminal -e './run.sh --push'");
}

void XiaomiTool::on_CameraB_clicked()
{
    system ("gnome-terminal -e './run.sh --camera'");
}

void XiaomiTool::on_APKB_clicked()
{
    system ("gnome-terminal -e './run.sh --apk'");
}

void XiaomiTool::on_ShellB_clicked()
{
    system ("gnome-terminal -e './run.sh --shell'");
}

void XiaomiTool::on_SRecB_clicked()
{
    system ("gnome-terminal -e './run.sh --srec'");
}

void XiaomiTool::on_RunTB_clicked()
{
    system ("gnome-terminal -e './run.sh '--runtime'");
}

void XiaomiTool::on_RecoveryB_clicked()
{
    system ("gnome-terminal -e './run.sh --recovery'");
}

void XiaomiTool::on_ZipB_clicked()
{
    system ("gnome-terminal -e './run.sh --flash'");
}

void XiaomiTool::on_RootB_clicked()
{
    system ("gnome-terminal -e './run.sh --root'");
}

void XiaomiTool::on_FastBootB_clicked()
{
    system ("gnome-terminal -e './run.sh --fastboot'");
}

void XiaomiTool::on_WDataB_clicked()
{
    system ("gnome-terminal -e './run.sh --wipe'");
}

void XiaomiTool::on_DeviceB_clicked()
{
    system ("gnome-terminal -e './run.sh --device'");
}

void XiaomiTool::on_ToolB_clicked()
{
    system ("gnome-terminal -e './run.sh --about'");
}
