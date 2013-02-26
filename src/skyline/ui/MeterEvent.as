package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.events.Event;

	public class MeterEvent extends Event
	{
		public static const METER_START : String = "MeterEventMeterStart";
		public static const METER_FULL : String = "MeterEventMeterFull";
	
		/**
		 * A text message that can be passed to an event handler
		 * with this event object.
		 */
		public var message:String;
		//public var id:Number

		/**
	 	 *  Constructor.
		 *  @param message The message of the event.
		 */
		public function MeterEvent(message:String = "MeterEvent event") {
			super(message);
			this.message = message;
		}

		/**
     * Creates and returns a copy of the current instance.
     * @return A copy of the current instance.
	   */
		public override function clone():Event {
			return new MeterEvent(message);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String {
			return formatToString("MeterEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		}
	}
}