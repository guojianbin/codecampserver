using System.Web.Mvc;
using CodeCampServer.Core.Domain;
using CodeCampServer.Core.Domain.Model;
using CodeCampServer.UI.Helpers.Filters;
using CodeCampServer.UI.Helpers.Mappers;
using CodeCampServer.UI.Models.Forms;

namespace CodeCampServer.UI.Controllers
{
	public class TrackController : SaveController<Track, TrackForm>
	{
		private readonly ITrackRepository _repository;

		private readonly ITrackMapper _mapper;
		private readonly ISessionRepository _sessionsRepository;

		public TrackController(ITrackRepository repository, ITrackMapper mapper, ISessionRepository sessionsRepository) : base(repository, mapper)
		{
			_repository = repository;
			_mapper = mapper;
			_sessionsRepository = sessionsRepository;
		}

		public ViewResult New(Conference conference)
		{
			var model = new TrackForm {ConferenceId = conference.Id, ConferenceKey = conference.Key};
			return View("Edit", model);
		}

		public ViewResult Index(Conference conference)
		{
			Track[] tracks = _repository.GetAllForConference(conference);
			return View(_mapper.Map(tracks));
		}

		public ViewResult Edit(Track track)
		{
			return View(_mapper.Map(track));
		}

		[ValidateModel(typeof (TrackForm))]
		public ActionResult Save([Bind(Prefix = "")] TrackForm trackForm)
		{
			return ProcessSave(trackForm, () => RedirectToAction<TrackController>(x => x.Index(null)));
		}

		public RedirectToRouteResult Delete(Track track)
		{
			if(_sessionsRepository.GetAllForTrack(track).Length==0)
			{
				_repository.Delete(track);
			}
			else
			{
				TempData.Add("message", "Track cannot be deleted.");
			}
			return RedirectToAction<TrackController>(x => x.Index(null));
		}
	}
}