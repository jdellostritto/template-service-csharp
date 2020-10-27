namespace template_service_csharp.DTO
{
    public class Greeting
    {
        
        public string content { get; set; }
        public long id {get; set;}
            
        
        /// <summary>
        /// Creates a populated greeting instance
        /// </summary>
        /// <param name="subject">Subject of Greeting.</param>
        /// <param name="id">Subject of Greeting.</param>
        public Greeting(long _id,string _content)
        {
            this.id = _id;
            this.content= _content;
            
        }

        public Greeting( string _content)
        {
            this.content = _content;

        }
    }

}
