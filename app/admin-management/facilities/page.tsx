import { createClient } from '@/lib/supabase/server'
import FacilitiesList from '@/components/management/FacilitiesList'

export default async function FacilitiesPage() {
  const supabase = await createClient()

  const [
    { data: services },
    { data: facilities, error }
  ] = await Promise.all([
    supabase.from('services').select('*').order('id'),
    supabase
      .from('facilities')
      .select(`
        *,
        service:services(name),
        prefecture:prefectures(name),
        area:areas(name),
        genre:genres(name),
        detail:facility_details!facility_id(name)
      `)
      .order('id', { ascending: false })
  ])

  if (error) {
    console.error('Error fetching facilities:', error)
  }

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">施設一覧</h1>
      </div>

      <FacilitiesList
        services={services || []}
        facilities={facilities || []}
        currentUserType="admin"
        currentUserCompanyId={null}
        showNewButton={true}
      />
    </div>
  )
}
