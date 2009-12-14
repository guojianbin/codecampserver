using System.Linq;
using CodeCampServer.Core.Domain;
using CodeCampServer.Core.Domain.Model;
using NHibernate;
using NHibernate.Criterion;

namespace CodeCampServer.Infrastructure.NHibernate.DataAccess.Impl
{
	public class UserRepository : RepositoryBase<User>, IUserRepository
	{
		public UserRepository(IUnitOfWork unitOfWork)
			: base(unitOfWork) 
		{
		}

		public User GetByUserName(string username)
		{
			ISession session = GetSession();
			IQuery query = session.CreateQuery("from User u where u.Username = :username");
			query.SetString("username", username);

			var matchingUser = query.UniqueResult<User>();

			return matchingUser;
		}

		public User[] GetLikeLastNameStart(string query)
		{
			return GetSession()
				.CreateCriteria(typeof (User))
				.Add(Restrictions.InsensitiveLike("Name", query, MatchMode.Start))
				.AddOrder(Order.Asc("Name"))
				.List<User>()
				.ToArray();
		}


        //protected override string GetEntityNaturalKeyName()
        //{
        //    return "Username";
        //}
	}
}