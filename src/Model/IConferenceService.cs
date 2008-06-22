using CodeCampServer.Model.Domain;

namespace CodeCampServer.Model
{
	public interface IConferenceService
	{
		Person[] GetAttendees(Conference conference, int page, int perPage);

		Person RegisterAttendee(string firstName, string lastName, string emailAddress, string website, string comment,
		                        Conference conference, string cleartextPassword);

		Conference GetCurrentConference();
	}
}