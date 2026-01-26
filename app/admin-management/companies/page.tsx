import { createClient } from '@/lib/supabase/server'
import CompanyManager from '@/components/management/CompanyManager'

export default async function CompaniesPage() {
  const supabase = await createClient()

  const { data: companies } = await supabase
    .from('companies')
    .select('*')
    .order('id', { ascending: false })

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-6">会社一覧</h1>
      <CompanyManager
        companies={companies || []}
        currentUserType="admin"
        currentUserCompanyId={null}
      />
    </div>
  )
}
