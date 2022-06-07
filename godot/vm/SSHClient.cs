using Godot;
using Renci.SshNet;
using Renci.SshNet.Async;
using System;
using System.Threading.Tasks;

public class SSHClient : Node
{
	[Signal]
	delegate void Outputed(String output);

	[Signal]
	delegate void Connected(Error error);

	private SshClient client = null;

	public async void Connect() {
		await Task.Run(() => {
			try {
				client = new SshClient("127.0.0.1", (int)GetTree().Root.GetNode("VM").Get("ssh_port"), "root", "whisper");
				client.Connect();
			} catch (Exception e) {
				GD.PushError(e.Message);
				EmitSignal("Connected", Error.Failed);
			}

			EmitSignal("Connected", Error.Ok);
		});
	}

	public async void RunCommand(String command) {
		if (client == null || !client.IsConnected) {
			GD.PushError("Can't run command. Client isn't connected!");
			return;
		}

		var output = await client.RunCommand(command).ExecuteAsync();
		EmitSignal("Outputed", output);
	}

    public override void _ExitTree()
    {
		client.Disconnect();
    }
}
