package;

import flixel.system.FlxSound;
#if desktop
import haxe.io.Bytes;
import lime.utils.UInt8Array;
import lime.media.vorbis.VorbisFile;
import lime.media.openal.AL;
import lime.media.vorbis.VorbisInfo;
#end

class AudioThing
{
	//DD: OpenAL doesn't work on HTML5, so fallback to FlxG.sound when on web
	#if desktop
	var vorb:VorbisFile;
	var _length:Float;
	var audioSource = AL.createSource();
	var audioBuffer = AL.createBuffer();
	#end

	public var volume(get, set):Float;
	public var time(get, set):Float;
	public var speed(get, set):Float;
	public var playing(get, never):Bool;
	public var stopped(get, never):Bool;
	public var length(get, never):Float;
	var elseSound:FlxSound;
	var _lostFocus:Bool = false;

	public var lostFocus(get, never):Bool;

	public function new(filePath:String)
	{
		#if desktop
		// DD: Use OpenAL manually for music to allow for speed change
		audioSource = AL.createSource();
		audioBuffer = AL.createBuffer();
		if (sys.FileSystem.exists(filePath))
		{
			vorb = VorbisFile.fromFile(filePath);
		}
		else
			return;
		var sndData = readVorbisFileBuffer(vorb);
		var vorbInfo:VorbisInfo = vorb.info();
		var vorbChannels = AL.FORMAT_STEREO16;
		if (vorbInfo.channels <= 1)
			vorbChannels = AL.FORMAT_MONO16;
		var vorbRate = vorbInfo.rate;
		_length = vorb.timeTotal() * 1000;
		AL.bufferData(audioBuffer, vorbChannels, sndData, sndData.length, vorbRate);
		AL.sourcei(audioSource, AL.BUFFER, audioBuffer);
		#else
		elseSound = new FlxSound().loadEmbedded(filePath);
		#end
	}

	//public var onComplete:Void->Void;

	public function play()
	{
		#if desktop
		if (audioSource != null)
			AL.sourcePlay(audioSource);
		#else
		elseSound.play();
		#end
		
	}

	public function pause()
	{
		#if desktop
		if (audioSource != null)
			AL.sourcePause(audioSource);
		#else
		elseSound.pause();
		#end
	}

	public function stop()
	{
		#if desktop
		if (audioSource != null)
			AL.sourceStop(audioSource);
		#else
		elseSound.stop();
		#end
	}

	inline function get_playing():Bool
	{
		#if desktop
		if (audioSource != null)
			return (AL.getSourcei(audioSource, AL.SOURCE_STATE) == AL.PLAYING);
		#else
		return elseSound.playing;
		#end
		return false;
	}

	inline function get_stopped():Bool
		{
			#if desktop
			if (audioSource != null)
				return (AL.getSourcei(audioSource, AL.SOURCE_STATE) == AL.STOPPED);
			#else
			return !elseSound.playing;
			#end
			return false;
		}

	inline function get_length():Float
	{
		#if desktop
		if (audioSource != null)
			return _length;
		#else
		return elseSound.length;
		#end
		return 0;
	}

	inline function get_volume():Float
	{
		#if desktop
		if (audioSource != null)
			return AL.getSourcef(audioSource, AL.GAIN);
		#else
		return elseSound.volume;
		#end
		return 0;
	}

	inline function set_volume(newVol:Float):Float
	{
		#if desktop
		if (audioSource != null)
			AL.sourcef(audioSource, AL.GAIN, newVol);
		#else
		elseSound.volume = newVol;
		#end
		return newVol;
	}

	inline function get_time():Float
	{
		#if desktop
		if (audioSource != null)
			return AL.getSourcef(audioSource, AL.SEC_OFFSET) * 1000;
		#else
		return elseSound.length;
		#end
		return 0;
	}

	function set_time(newTime:Float):Float
	{
		#if desktop
		if (audioSource != null)
			AL.sourcef(audioSource, AL.SEC_OFFSET, newTime/1000);
		#else
		elseSound.time = newTime;
		#end
		return newTime;
	}

	inline function get_speed():Float
	{
		#if desktop
		if (audioSource != null)
			return AL.getSourcef(audioSource, AL.PITCH);
		#else
		return 1.0;
		#end
		return 0;
	}

	function set_speed(newSpeed:Float):Float
	{
		#if desktop
		if (audioSource != null)
			AL.sourcef(audioSource, AL.PITCH, newSpeed);
		return newSpeed;
		#end
		return 1.0;
	}

	inline function get_lostFocus():Bool
	{
		return _lostFocus;
	}

	public function loseFocus()
	{
		_lostFocus = true;
		pause();
	}

	public function regainFocus()
	{
		_lostFocus = false;
		play();
	}

	#if (desktop)
	// DD: Just gonna take this from my other mod.
	function readVorbisFileBuffer(vorbisFile:VorbisFile):UInt8Array
	{
		var length = Std.int(vorbisFile.bitrate() * vorbisFile.timeTotal() * vorbisFile.info().rate/10000);
		var buffer = Bytes.alloc(length);
		var read = 0, total = 0, readMax;

		while (total < length)
		{
			readMax = 4096;

			if (readMax > length - total)
			{
				readMax = length - total;
			}

			read = vorbisFile.read(buffer, total, readMax);

			if (read > 0)
			{
				total += read;
			}
			else
			{
				break;
			}
		}

		var realbuffer = new UInt8Array(total);
		realbuffer.buffer.blit(0, buffer, 0, total);

		return realbuffer;
	}
	#end
}
