package skyline.ui{

	/**
	Constructs a 

	*/

	import flash.events.Event;

	public class NavEvent extends Event
	{
		
		public static const SELECT : String = "NavEventSelect";
		public static const SELECT_FIRST : String = "NavEventSelectFirst";
		public static const SELECT_CITY : String = "NavEventSelectCity";
		public static const SELECT_PROJECT : String = "NavEventSelectProject";
	
		/**
		 * A text message that can be passed to an event handler
		 * with this event object.
		 */
		public var message:String;
		public var id:Number

		/**
	 	 *  Constructor.
		 *  @param message The message of the event.
		 */
		public function NavEvent(message:String = "NavEvent event", id:Number = NaN) {
			super(message);
			this.message = message;
			this.id = id;
		}

		/**
     * Creates and returns a copy of the current instance.
     * @return A copy of the current instance.
	   */
		public override function clone():Event {
			return new NavEvent(message);
		}

		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String {
			return formatToString("NavEvent", "type", "bubbles", "cancelable", "eventPhase", "message");
		}
	}
}