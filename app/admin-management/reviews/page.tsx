import { createClient } from '@/lib/supabase/server'
import ReviewChecksList from '@/components/management/ReviewChecksList'

export default async function ReviewsPage() {
  const supabase = await createClient()

  // Fetch services, facilities, and review_checks with facility info
  const [
    { data: services },
    { data: facilities },
    { data: reviewChecks, error }
  ] = await Promise.all([
    supabase.from('services').select('*').order('id'),
    supabase.from('facilities').select('id, service_id, company_id'),
    supabase
      .from('review_checks')
      .select(`
        *,
        facility:facilities(
          id,
          service_id,
          detail:facility_details!facility_id(name)
        ),
        tasks:review_check_tasks(id, status)
      `)
      .order('id', { ascending: false })
  ])

  if (error) {
    console.error('Error fetching review_checks:', error)
  }

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">クチコミ一覧</h1>
      </div>

      <ReviewChecksList
        services={services || []}
        reviewChecks={reviewChecks || []}
        facilities={facilities || []}
        currentUserType="admin"
        currentUserCompanyId={null}
        showNewButton={true}
      />
    </div>
  )
}
