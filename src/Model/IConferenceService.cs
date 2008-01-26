using System.Collections.Generic;
using CodeCampServer.Model.Domain;
using Iesi.Collections.Generic;
using StructureMap;

namespace CodeCampServer.Model
{
	[PluginFamily(Keys.DEFAULT)]
	public interface IConferenceService
	{
		Conference GetConference(string conferenceKey);
		Attendee[] GetAttendees(Conference conference, int page, int perPage);
		Attendee RegisterAttendee(string firstName, string lastName, string website, string comment, Conference conference, string emailAddress, string cleartextPassword);

        string GetLoggedInUsername();

        Session CreateSession(Speaker speaker, string title, string @abstract, OnlineResource[] onlineResources);
        IEnumerable<Conference> GetAllConferences();
        Speaker GetLoggedInSpeaker();
        Speaker GetSpeakerByDisplayName(string displayName);
        Speaker GetSpeakerByEmail(string email);
        IEnumerable<Speaker> GetSpeakers(Conference conference, int page, int perPage);
        Speaker SaveSpeaker(string emailAddress, string firstName, string lastName, string website, string comment, string displayName, string profile, string avatarUrl);
    }
}
