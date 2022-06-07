using System.Threading.Tasks;
using Godot;
using MQTTnet;
using MQTTnet.Client;
using MQTTnet.Client.Options;
using MQTTnet.Client.Disconnecting;
using MQTTnet.Client.Receiving;
using MQTTnet.Client.Connecting;
using System;
using System.Threading;

public class MQTTClient : Node
{
	[Signal]
	delegate void MessageReceived(String message);

	[Signal]
	delegate void Disconnected(String reason);

	[Export]
	public bool Autostart = true;
	
	[Export]
	public string Topic = "#";

	private IMqttClient client;

	public override void _Ready()
	{
		if (Autostart) {
			Connect();
		}
	}

	public async void Connect(int port = 5077) {
		await Task.Run(async () => {
			var mqttFactory = new MqttFactory();
			client = mqttFactory.CreateMqttClient();

			var opts = new MqttClientOptionsBuilder()
				.WithTcpServer("127.0.0.1", port)
				.WithKeepAlivePeriod(new TimeSpan(5 * TimeSpan.TicksPerSecond))
				.Build();

			client.ApplicationMessageReceivedHandler = new MqttApplicationMessageReceivedHandlerDelegate(e => {
				var message = e.ApplicationMessage.ConvertPayloadToString();
				EmitSignal("MessageReceived", message);
			});
			
			client.DisconnectedHandler = new MqttClientDisconnectedHandlerDelegate(e => {
				EmitSignal("Disconnected", e.Reason.ToString()); 
			});

			try {
				await client.ConnectAsync(opts);
			} catch (Exception e) {
				GD.PrintErr(e.Message);
				return;
			}

			var subOpts = mqttFactory.CreateSubscribeOptionsBuilder()
				.WithTopicFilter(f => { f.WithTopic(Topic); })
				.Build();

			await client.SubscribeAsync(subOpts);
		});
	}

	public override void _ExitTree()
	{
		client.DisconnectAsync(new MqttClientDisconnectOptions());
	}
}
